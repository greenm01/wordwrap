package wordwrap

import "core:fmt"
import "core:strings"

main :: proc() {

	cases := []struct {
		input, output: string,
		lim:           uint,
	} {
		// A simple word passes through.
		{"foo", "foo", 4},
		// A single word that is too long passes through.
		// We do not break words.
		{"foobarbaz", "foobarbaz", 4},
		// Lines are broken at whitespace.
		{"foo bar baz", "foo\nbar\nbaz", 4},
		// Lines are broken at whitespace, even if words
		// are too long. We do not break words.
		{"foo bars bazzes", "foo\nbars\nbazzes", 4},
		// A word that would run beyond the width is wrapped.
		{"fo sop", "fo\nsop", 4},
		// Do not break on non-breaking space.
		{"foo bar\u00A0baz", "foo\nbar\u00A0baz", 10},
		// Whitespace that trails a line and fits the width
		// passes through, as does whitespace prefixing an
		// explicit line break. A tab counts as one character.
		{"foo\nb\t r\n baz", "foo\nb\t r\n baz", 4},
		// Trailing whitespace is removed if it doesn't fit the width.
		// Runs of whitespace on which a line is broken are removed.
		{"foo    \nb   ar   ", "foo\nb\nar", 4},
		// An explicit line break at the end of the input is preserved.
		{"foo bar baz\n", "foo\nbar\nbaz\n", 4},
		// Explicit break are always preserved.
		{"\nfoo bar\n\n\nbaz\n", "\nfoo\nbar\n\n\nbaz\n", 4},
		// Complete example:
		 {
			" This is a list: \n\n\t* foo\n\t* bar\n\n\n\t* baz  \nBAM    ",
			" This\nis a\nlist: \n\n\t* foo\n\t* bar\n\n\n\t* baz\nBAM",
			6,
		},
		// Multi-byte characters
		 {
			strings.repeat("\u2584 ", 4),
			strings.concatenate([]string{"\u2584 \u2584", "\n", strings.repeat("\u2584 ", 2)}),
			4,
		},
	}

	errors := 0
	for tc, i in cases {
		actual := wrap_string(tc.input, tc.lim)
		if actual != tc.output {
			errors += 1
			fmt.printf(
				"Case %d Input:\n\n`%s`\n\nExpected Output:\n\n`%s`\n\nActual Output:\n\n`%s`",
				i,
				tc.input,
				tc.output,
				actual,
			)
		}
	}

	if errors == 0 do fmt.println("No errors... success!")

}
