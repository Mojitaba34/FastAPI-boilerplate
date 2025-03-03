from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file="../.env")
    # Write every env variable name here and then use it on the code


def get_settings() -> Settings:
    return Settings()
