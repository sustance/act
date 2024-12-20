#!/usr/bin/env python3
import requests
import time
from datetime import datetime
import logging
from typing import Dict, Tuple

class SimpleVentilationMonitor:
    def __init__(self, weather_api_key: str, telegram_bot_token: str, telegram_chat_id: str):
        self.weather_api_key = weather_api_key
        self.telegram_token = telegram_bot_token
        self.telegram_chat_id = telegram_chat_id
        self.last_message_time = {}  # Prevent spam
        
        # Configure logging
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(message)s'
        )
        
    def get_weather_data(self, city: str) -> Dict:
        """Fetch current weather and forecast"""
        try:
            url = f"https://api.weatherapi.com/v1/forecast.json?key={self.weather_api_key}&q={city}&days=2"
            response = requests.get(url)
            return response.json()
        except Exception as e:
            logging.error(f"Weather API error: {e}")
            return None

    def send_telegram_message(self, message: str) -> None:
        """Send Telegram notification"""
        # Only send the same message once per hour
        if message in self.last_message_time:
            if (datetime.now() - self.last_message_time[message]).total_seconds() < 3600:
                return

        try:
            url = f"https://api.telegram.org/bot{self.telegram_token}/sendMessage"
            data = {
                "chat_id": self.telegram_chat_id,
                "text": message
            }
            requests.post(url, data=data)
            self.last_message_time[message] = datetime.now()
            logging.info(f"Sent message: {message}")
        except Exception as e:
            logging.error(f"Telegram error: {e}")

    def check_conditions(self, weather_data: Dict) -> Tuple[bool, str]:
        """Analyze weather conditions and return recommendations"""
        if not weather_data:
            return False, "Weather data unavailable"

        current = weather_data['current']
        forecast = weather_data['forecast']['forecastday'][0]
        
        humidity = current['humidity']
        temp = current['temp_c']
        wind_kph = current['wind_kph']
        rain_chance = forecast['day']['daily_chance_of_rain']
        
        conditions = []
        should_ventilate = True

        # Check each condition
        if humidity < 40:
            conditions.append("Humidity too low")
            should_ventilate = False
        elif humidity > 70:
            conditions.append("High humidity alert")

        if wind_kph > 25:
            conditions.append("Strong wind warning")
            should_ventilate = False

        if rain_chance > 50:
            conditions.append("High rain probability")
            should_ventilate = False

        # Create message
        time_str = datetime.now().strftime("%H:%M")
        message = f"🏠 Ventilation Check ({time_str}):\n"
        message += f"Temperature: {temp}°C\n"
        message += f"Humidity: {humidity}%\n"
        message += f"Wind: {wind_kph} km/h\n"
        message += f"Rain chance: {rain_chance}%\n\n"

        if should_ventilate:
            message += "✅ Good conditions for ventilation!"
        else:
            message += "❌ Not recommended to ventilate because:\n"
            message += "\n".join(f"- {c}" for c in conditions)

        return should_ventilate, message

def main():
    # Replace these with your actual API keys and location
    WEATHER_API_KEY = "your_weather_api_key"
    TELEGRAM_BOT_TOKEN = "your_telegram_bot_token"
    TELEGRAM_CHAT_ID = "your_chat_id"
    CITY = "your_city"
    
    monitor = SimpleVentilationMonitor(
        WEATHER_API_KEY,
        TELEGRAM_BOT_TOKEN,
        TELEGRAM_CHAT_ID
    )
    
    while True:
        weather_data = monitor.get_weather_data(CITY)
        should_ventilate, message = monitor.check_conditions(weather_data)
        
        # Send notification
        monitor.send_telegram_message(message)
        
        # Wait for 30 minutes before next check
        time.sleep(1800)

if __name__ == "__main__":
    main()
