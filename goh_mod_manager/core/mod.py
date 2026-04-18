# AI-generated code, human reviewed
from dataclasses import dataclass


@dataclass
class Mod:
    id: str
    name: str
    desc: str
    minGameVersion: str
    maxGameVersion: str
    require: str
    folderPath: str
    manualInstall: bool
    alias: str = ""  # AI-generated: Added alias field for mod notes

    def __str__(self):
        # AI-generated: Support alias display format
        if self.alias:
            return f"{self.alias} | {self.name}"
        return f"{self.name}"
