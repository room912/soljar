defmodule Soljar.Mailer do
  use Swoosh.Mailer, otp_app: :soljar

  def send_tg_message(email, message) do
    Telegram.Api.request(Application.get_env(:soljar, :tg_bot_token), "sendMessage",
      chat_id: -4109602076, # temporary static for specific chat group
      text: "#{email}: #{message}"
    )
  end
end
