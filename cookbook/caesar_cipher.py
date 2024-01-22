import sys


def get_shift(start, end):
    """Calculate the shift amount between two characters."""
    return (ord(end.upper()) - ord(start.upper())) % 26


def caesar_cipher(text, shift):
    """Encode the text using Caesar cipher with the given shift."""
    result = ""
    for char in text:
        if char.isalpha():
            # Calculate shifted character keeping case in mind
            base = ord("A") if char.isupper() else ord("a")
            shifted = (ord(char) - base + shift) % 26 + base
            result += chr(shifted)
        else:
            result += char
    return result


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python script.py <start_letter> <end_letter> <text>")
        sys.exit(1)

    start_letter, end_letter, text = sys.argv[1], sys.argv[2], sys.argv[3]

    # Check if the start and end letters are valid (single characters and alphabetic)
    if not (
        start_letter.isalpha()
        and end_letter.isalpha()
        and len(start_letter) == 1
        and len(end_letter) == 1
    ):
        print("Start and end letters must be single alphabetic characters.")
        sys.exit(1)

    shift = get_shift(start_letter, end_letter)
    encoded_text = caesar_cipher(text, shift)
    print(encoded_text)
