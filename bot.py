import discord
from discord.ext import commands
from discord.ui import Button, View
import requests
import json
import os


TOKEN = 'MTMwMjE4NzkzODA2MjI3NDU3MQ.GDqzuK.V4amGRz0V0my4WNuPZgboPoWamJKDKvoLNm8kY'
MODERATORS = ["jevilxs"]
DEVELOPERS = ["jevilxs"]

BANS_FILE = "bans.json"
banned_users = {}

LANG = {
    "ru": {
        "banned": "⛔ Вы забанены.\nПричина: {}",
        "ticket_button": "🎫 Создать тикет",
        "ticket_prompt": "✏️ Напишите, что у вас случилось.",
        "ticket_timeout": "⏰ Время ожидания истекло.",
        "ticket_created": "✅ Тикет отправлен модераторам!",
        "ticket_closed": "✅ Ответ отправлен.",
        "no_access": "❌ Нет доступа.",
        "reply_prompt": "✉️ Напишите ответ пользователю.",
        "developer_panel": "🛠️ Панель разработчика",
        "ban_success": "🔒 Пользователь **{}** был забанен.\nПричина: {}",
        "unban_success": "✅ Пользователь **{}** был разбанен.",
        "banned_dm": "❗ Вы были забанены.\nПричина: {}",
        "unbanned_dm": "✅ Вы были разбанены и снова можете использовать бота!"
    }
}

LANGUAGE = "ru"

intents = discord.Intents.default()
intents.messages = True
intents.guilds = True
intents.members = True
intents.message_content = True

bot = commands.Bot(command_prefix='!', intents=intents)
bot.remove_command('help')

active_tickets = set()         
moderators_busy = set()       
ticket_in_process = {} 

def load_bans():
    global banned_users
    if os.path.exists(BANS_FILE):
        with open(BANS_FILE, "r") as f:
            try:
                banned_users = json.load(f)
                banned_users = {int(k): v for k, v in banned_users.items()}
            except json.JSONDecodeError:
                banned_users = {}

def save_bans():
    with open(BANS_FILE, "w") as f:
        json.dump(banned_users, f)

@bot.command()
async def ban(ctx, user: discord.User, *, reason="Без причины"):
    if ctx.author.name not in DEVELOPERS:
        return
    banned_users[user.id] = {
        "reason": reason,
        "moderator": ctx.author.name
    }
    save_bans()
    await ctx.send(embed=discord.Embed(description=LANG[LANGUAGE]["ban_success"].format(user.name, reason), color=discord.Color.red()))
    try:
        await user.send(embed=discord.Embed(description=LANG[LANGUAGE]["banned_dm"].format(reason), color=discord.Color.dark_red()))
    except:
        pass

@bot.command()
async def banlist(ctx):
    if ctx.author.name not in DEVELOPERS:
        await ctx.send(LANG[LANGUAGE]["no_access"])
        return

    if not banned_users:
        await ctx.send("✅ Список банов пуст.")
        return

    embed = discord.Embed(title="📄 Список забаненных пользователей", color=discord.Color.red())

    for user_id, ban_data in banned_users.items():
        user_tag = f"<@{user_id}>"
        reason = ban_data.get("reason", "Без причины")
        moderator = ban_data.get("moderator", "Неизвестно")
        embed.add_field(
            name=f"🚫 {user_tag}",
            value=f"**Причина:** {reason}\n**Модератор:** {moderator}",
            inline=False
        )

    await ctx.send(embed=embed)

@bot.command()
async def unban(ctx, user: discord.User):
    if ctx.author.name not in DEVELOPERS:
        return
    if user.id in banned_users:
        del banned_users[user.id]
        save_bans()
        await ctx.send(embed=discord.Embed(description=LANG[LANGUAGE]["unban_success"].format(user.name), color=discord.Color.green()))
        try:
            await user.send(embed=discord.Embed(description=LANG[LANGUAGE]["unbanned_dm"], color=discord.Color.green()))
        except:
            pass

@bot.check
async def only_dm(ctx):
    if ctx.guild is not None:
        try:
            await ctx.send("🚫 Эта команда работает только в личных сообщениях!")
        except discord.Forbidden:
            pass  
        return False  
    return True  

@bot.check
async def check_ban(ctx):
    if ctx.author.id in banned_users:
        reason = banned_users[ctx.author.id]["reason"]
        try:
            await ctx.send(embed=discord.Embed(description=LANG[LANGUAGE]["banned"].format(reason), color=discord.Color.red()))
        except:
            pass
        return False
    return True

class TicketView(View):
    def __init__(self, author_id):
        super().__init__(timeout=None)
        self.author_id = author_id

    @discord.ui.button(label=LANG[LANGUAGE]["ticket_button"], style=discord.ButtonStyle.green, custom_id="create_ticket")
    async def create_ticket_button(self, interaction: discord.Interaction, button: Button):
        user_id = interaction.user.id

        if user_id in active_tickets:
            await interaction.response.send_message("❗ Уже создан тикет.", ephemeral=True)
            return

        if user_id != self.author_id:
            await interaction.response.send_message("❗ Только вы можете создать тикет.", ephemeral=True)
            return

        active_tickets.add(user_id)
        await interaction.response.send_message(LANG[LANGUAGE]["ticket_prompt"], ephemeral=True)

        def check(msg):
            return msg.author.id == user_id and msg.channel == interaction.channel

        try:
            msg = await bot.wait_for('message', check=check, timeout=120)
        except:
            active_tickets.remove(user_id)
            await interaction.followup.send(LANG[LANGUAGE]["ticket_timeout"], ephemeral=True)
            return


        take_view = View()
        take_button = Button(label="📥 Взять на рассмотрение", style=discord.ButtonStyle.green)

        async def take_callback(take_interaction: discord.Interaction):
            mod_id = take_interaction.user.id

            if take_interaction.user.name not in MODERATORS:
                await take_interaction.response.send_message(LANG[LANGUAGE]["no_access"], ephemeral=True)
                return

            if mod_id in moderators_busy:
                await take_interaction.response.send_message("❗ Вы уже взяли другой тикет.", ephemeral=True)
                return

            if user_id in ticket_in_process:
                await take_interaction.response.send_message("❗ Этот тикет уже взят другим модератором.", ephemeral=True)
                return


            moderators_busy.add(mod_id)
            ticket_in_process[user_id] = mod_id

            await take_interaction.response.edit_message(content=f"Тикет взят модератором {take_interaction.user.mention}", view=close_view)


            user = await bot.fetch_user(user_id)
            await user.send(f"📥 Ваш тикет взят модератором {take_interaction.user.name}. Можете писать свои вопросы сюда.")

        take_button.callback = take_callback
        take_view.add_item(take_button)


        close_view = View()
        close_button = Button(label="🔒 Закрыть тикет", style=discord.ButtonStyle.danger)

        async def close_callback(close_interaction: discord.Interaction):
            mod_id = close_interaction.user.id

            if mod_id not in moderators_busy:
                await close_interaction.response.send_message(LANG[LANGUAGE]["no_access"], ephemeral=True)
                return

            if user_id not in ticket_in_process or ticket_in_process[user_id] != mod_id:
                await close_interaction.response.send_message("❗ Вы не взяли этот тикет.", ephemeral=True)
                return


            active_tickets.remove(user_id)
            moderators_busy.remove(mod_id)
            del ticket_in_process[user_id]

            await close_interaction.response.send_message(LANG[LANGUAGE]["ticket_closed"], ephemeral=True)


            user = await bot.fetch_user(user_id)
            try:
                await user.send(f"✅ Ваш тикет был закрыт модератором {close_interaction.user.name}. Спасибо!")
            except:
                pass

        close_button.callback = close_callback
        close_view.add_item(close_button)

        embed = discord.Embed(
            title="🎫 Новый тикет",
            description=f"**От:** {interaction.user.mention}\n**Сообщение:**\n{msg.content}",
            color=discord.Color.blue()
        )


        moderator_names = set()

        for guild in bot.guilds:
            for member in guild.members:
                if member.name in MODERATORS:
                    moderator_names.add(member.name)

        for mod_name in moderator_names:
            try:
                
                for guild in bot.guilds:
                    member = discord.utils.find(lambda m: m.name == mod_name, guild.members)
                    if member:
                        await member.send(embed=embed, view=take_view)
                        break
            except:
                continue

        await interaction.followup.send(LANG[LANGUAGE]["ticket_created"], ephemeral=True)

class TicketModerationView(View):
    def __init__(self, ticket_author_id):
        super().__init__(timeout=None)
        self.ticket_author_id = ticket_author_id
        self.claimed = False
        self.moderator_id = None

    @discord.ui.button(label="Взять на рассмотрение", style=discord.ButtonStyle.green)
    async def take_button(self, interaction: discord.Interaction, button: Button):
        if interaction.user.name not in MODERATORS:
            await interaction.response.send_message(LANG[LANGUAGE]["no_access"], ephemeral=True)
            return

        if interaction.user.id in moderators_busy:
            await interaction.response.send_message("Вы уже рассматриваете другой тикет.", ephemeral=True)
            return

        if self.claimed:
            await interaction.response.send_message("Этот тикет уже взят другим модератором.", ephemeral=True)
            return


        self.claimed = True
        self.moderator_id = interaction.user.id
        moderators_busy.add(interaction.user.id)
        ticket_in_process[self.ticket_author_id] = interaction.user.id

        await interaction.response.send_message(f"Вы взяли тикет от <@{self.ticket_author_id}> на рассмотрение.", ephemeral=True)

        try:
            user = await bot.fetch_user(self.ticket_author_id)
            await user.send(f"Ваш тикет взят на рассмотрение модератором {interaction.user.name}. Можете писать сюда.")
        except:
            pass

    @discord.ui.button(label="Закрыть тикет", style=discord.ButtonStyle.red)
    async def close_button(self, interaction: discord.Interaction, button: Button):
        if interaction.user.id not in moderators_busy:
            await interaction.response.send_message(LANG[LANGUAGE]["no_access"], ephemeral=True)
            return

        if ticket_in_process.get(self.ticket_author_id) != interaction.user.id:
            await interaction.response.send_message("Вы не являетесь ответственным за этот тикет.", ephemeral=True)
            return

        # Закрываем тикет
        active_tickets.discard(self.ticket_author_id)
        moderators_busy.discard(interaction.user.id)
        ticket_in_process.pop(self.ticket_author_id, None)

        await interaction.response.send_message(LANG[LANGUAGE]["ticket_closed"], ephemeral=True)

        try:
            user = await bot.fetch_user(self.ticket_author_id)
            await user.send("Ваш тикет был закрыт.")
        except:
            pass

@bot.command()
async def ticket(ctx):
    view = TicketView(ctx.author.id)
    embed = discord.Embed(title="🎟️ Тикет", description="Нажмите кнопку ниже для создания тикета.", color=discord.Color.blurple())
    await ctx.send(embed=embed, view=view)

@bot.command()
async def developer(ctx):
    if ctx.author.name not in DEVELOPERS:
        return
    embed = discord.Embed(title=LANG[LANGUAGE]["developer_panel"], description="Команды разработчика:", color=discord.Color.dark_red())
    embed.add_field(name="!ban [пользователь] [причина]", value="🔒 Забанить пользователя", inline=False)
    embed.add_field(name="!unban [пользователь]", value="🔓 Разбанить пользователя", inline=False)
    embed.add_field(name="!developer", value="⚙️ Панель разработчика", inline=False)
    await ctx.send(embed=embed)

class HelpMenu(View):
    def __init__(self):
        super().__init__(timeout=None)

        self.main_embed = discord.Embed(
            title="📘 Меню помощи",
            description="Выберите категорию команд ниже 👇",
            color=discord.Color.purple()
        )

        self.embeds = {
            "main": discord.Embed(
                title="📌 Основные команды",
                description="`!help`, `!ticket`, `!info`",
                color=discord.Color.blue()
            ),
            "fun": discord.Embed(
                title="🎉 Развлекательные команды",
                description="`!joke`, `!cat`, `!dog`",
                color=discord.Color.green()
            )
        }

    @discord.ui.button(label="📌 Основные", style=discord.ButtonStyle.primary)
    async def main_button_callback(self, interaction: discord.Interaction, button: Button):
        await interaction.response.edit_message(embed=self.embeds["main"], view=self)

    @discord.ui.button(label="🎉 Развлечения", style=discord.ButtonStyle.success)
    async def fun_button_callback(self, interaction: discord.Interaction, button: Button):
        await interaction.response.edit_message(embed=self.embeds["fun"], view=self)

@bot.command()
async def help(ctx):
    view = HelpMenu()
    await ctx.send(embed=view.main_embed, view=view)

@bot.command()
async def info(ctx):
    embed = discord.Embed(title="ℹ️ Информация", description="Многофункциональный бот Discord.", color=discord.Color.green())
    embed.add_field(name="Версия", value="2.0")
    await ctx.send(embed=embed)

@bot.command()
async def joke(ctx):
    try:
        res = requests.get("https://official-joke-api.appspot.com/random_joke")
        data = res.json()
        await ctx.send(f"🎭 {data['setup']}\n||{data['punchline']}||")
    except:
        pass

@bot.command()
async def cat(ctx):
    try:
        res = requests.get("https://api.thecatapi.com/v1/images/search")
        url = res.json()[0]['url']
        embed = discord.Embed(title="😺 Котик!", color=discord.Color.orange())
        embed.set_image(url=url)
        await ctx.send(embed=embed)
    except:
        pass

@bot.command()
async def dog(ctx):
    try:
        res = requests.get("https://dog.ceo/api/breeds/image/random")
        url = res.json()['message']
        embed = discord.Embed(title="🐶 Пёсик!", color=discord.Color.orange())
        embed.set_image(url=url)
        await ctx.send(embed=embed)
    except:
        pass

@bot.event
async def on_message(message):
    await bot.process_commands(message)


    if message.author.bot:
        return


    if isinstance(message.channel, discord.DMChannel):
        user_id = message.author.id
        if user_id in ticket_in_process:

            mod_id = ticket_in_process[user_id]
            mod = await bot.fetch_user(mod_id)
            await mod.send(f"📩 От <@{user_id}>: {message.content}")
        elif user_id in moderators_busy:
            for t_user, mod_id in ticket_in_process.items():
                if mod_id == user_id:
                    user = await bot.fetch_user(t_user)
                    await user.send(f"📩 Ответ от модератора: {message.content}")
                    break

@bot.event
async def on_ready():
    load_bans()
    print(f"Бот запущен: {bot.user}")

bot.run(TOKEN)
