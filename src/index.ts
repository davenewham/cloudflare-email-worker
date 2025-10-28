import PostalMime from 'postal-mime';
import { Env } from './interfaces/env';

export default {
  async email(message: ForwardableEmailMessage, env: Env, _ctx: ExecutionContext): Promise<void> {
    try {
      const BOT_TOKEN = env.BOT_TOKEN;
      const CHANNEL_ID = env.CHANNEL_ID;

      const email = await PostalMime.parse(message.raw);
      if (email.text) {

        // truncate to 4096 to telegram messagelimit
        await fetch(`https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            chat_id: CHANNEL_ID,
            text: email.text.slice(0, 4096),
          }),
        });
      }

    } catch (error) {
      console.error('Error:', error);

      // throw to let cf know
      throw error;
    }
  }
} satisfies ExportedHandler<Env>;