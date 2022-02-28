from libqtile.config import Group
import rules


def get_workspaces_list():
    web_workspace = Group(name="web", label="",
                          matches=rules.WEB_MATCHES, exclusive=True, layout="max")
    term_workspace = Group(name="term", label="",
                           matches=rules.TERM_MATCHES, exclusive=True, layout="MonadTall")
    doc_workspace = Group(
        "doc", label="", matches=rules.DOC_MATCHES, exclusive=True, layout="MonadTall")
    dev_workspace = Group(
        "dev", label="", matches=rules.DEV_MATCHES, exclusive=True, layout="max")
    media_workspace = Group(
        "media", label="", matches=rules.MEDIA_MATCHES, exclusive=True, layout="max")
    gaming_workspace = Group(
        "gaming", label="", matches=rules.GAMING_MATCHES, exclusive=True, layout="max")
    music_workspace = Group(
        "music", label="", matches=rules.MUSIC_MATCHES, exclusive=True, layout="max")
    anything_workspace = Group("other", label="", matches=rules.OTHER_MATCHES,
                               exclusive=False, persist=False, init=False)

    workspace_list = [
        web_workspace,
        term_workspace,
        music_workspace,
        dev_workspace,
        media_workspace,
        doc_workspace,
        gaming_workspace,
        anything_workspace
    ]

    return workspace_list
