#!/usr/bin/env python3
"""
statusline-line2.py
Claude Code ステータスライン 2行目レンダラー。
モデル名・コンテキスト使用量・レートリミットを
グラデーション付きプログレスバーで表示する。
"""

import json
import sys

# stdin から JSON を読み込む
data = json.load(sys.stdin)

# ---------- ANSI エスケープ定数 ----------
# リセット
RESET = '\033[0m'
# ディム（薄暗い表示）
DIM = '\033[2m'
# セパレータ用のディムバー
SEP = f'{DIM}│{RESET}'

# 8段階のブロック文字（左端=空白 〜 右端=全埋まり）
BLOCKS = ' ▏▎▍▌▋▊▉█'


def gradient_color(pct: float) -> str:
    """
    使用率 pct (0〜100) に応じたトゥルーカラー ANSI 前景色コードを返す。

    - 0〜50%: 緑（赤成分が 0→127 へ増加、緑 200 固定、青 80 固定）
    - 50〜100%: 黄→赤（赤 255 固定、緑成分が 200→0 へ減少）
    """
    if pct < 50:
        r = int(pct * 5.1)        # 0〜127 程度に増加
        return f'\033[38;2;{r};200;80m'
    else:
        g = int(200 - (pct - 50) * 4)  # 200〜0 へ減少
        return f'\033[38;2;255;{max(g, 0)};60m'


def make_bar(pct: float, width: int = 10) -> str:
    """
    8段階精度のプログレスバー文字列を生成する。

    Args:
        pct: 使用率（0〜100）
        width: バーの文字幅（デフォルト 10）

    Returns:
        グラデーション色付きのバー文字列（ANSI コード込み）
    """
    pct = min(max(pct, 0), 100)

    # 小数点以下を含む「埋まり量」を計算
    filled_f = pct * width / 100
    full = int(filled_f)                  # 完全に埋まったブロック数
    frac = int((filled_f - full) * 8)    # 端数を 8段階に変換

    # バー文字列を組み立て
    bar = '█' * full
    if full < width:
        bar += BLOCKS[frac]               # 端数ブロック
        bar += '░' * (width - full - 1)  # 残りは空ブロック

    # グラデーション色を適用してリセット
    color = gradient_color(pct)
    return f'{color}{bar}{RESET}'


def fmt_metric(label: str, pct: float) -> str:
    """
    ラベル・バー・パーセント表示を組み合わせた 1メトリクス分の文字列を返す。

    Args:
        label: 表示ラベル（例: 'ctx', '5h', '7d'）
        pct: 使用率（0〜100）

    Returns:
        フォーマット済み文字列（例: 'ctx ████████░░ 80%'）
    """
    p = round(pct)
    bar = make_bar(pct)
    color = gradient_color(pct)
    return f'{label} {bar} {color}{p}%{RESET}'


# ---------- データ取得 ----------
model = data.get('model', {}).get('display_name') \
        or data.get('model', {}).get('id') \
        or 'Unknown'

ctx_pct   = data.get('context_window', {}).get('used_percentage')
five_pct  = data.get('rate_limits', {}).get('five_hour', {}).get('used_percentage')
seven_pct = data.get('rate_limits', {}).get('seven_day', {}).get('used_percentage')

# ---------- パーツ組み立て ----------
parts = [model]

# コンテキスト使用量（値がない場合はプレースホルダーを表示）
if ctx_pct is not None:
    parts.append(fmt_metric('ctx', ctx_pct))
else:
    parts.append(f'ctx {"░" * 10} --%')

# 5時間レートリミット（存在する場合のみ表示）
if five_pct is not None:
    parts.append(fmt_metric('5h', five_pct))

# 7日間レートリミット（存在する場合のみ表示）
if seven_pct is not None:
    parts.append(fmt_metric('7d', seven_pct))

# セパレータで結合して出力（末尾改行なし）
print(f' {SEP} '.join(parts), end='')
