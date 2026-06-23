"""joinmultiplayer — the agent-native 'ask the network' connector.

Run it (no install needed) with:  uvx joinmultiplayer   (or `pipx run joinmultiplayer`)
It distills your local AI history into shareable TOPIC LABELS, registers you as a node on
joinmultiplayer.ai, and (on macOS) installs an always-on answerer that replies to network
questions from YOUR own memory — no tools, fail-closed redaction. Your raw history never leaves
the machine; only the short labels. No signup, no account, no credentials.
"""
from .connector import main

__all__ = ["main"]
__version__ = "0.1.4"
