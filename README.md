# The Transconv package for LuaTeX

As a linguist who works on East Asian languages, I frequently have to render
languages in the Latin script which do not usually use it. While for some
contexts, the IPA is certainly the best way to go, there are many situations
where it is either unnecessarily unwieldy or omits certain information (e.g.
historical one) which may be crucial to the discussion. Therefore, it is often
more practical to use a transcription scheme to transcribe the pronunciation
(and sometimes certain aspects of the orthography) into (usually) the Latin
script. For example, we may use Hanyu Pinyin to transcribe Standard Chinese.

However, these schemes almost always pose at least one of these two problems on
a LaTeX user:

* They use non-ASCII characters which may be annoying to input, e.g.
  diacritics, super- or subscripts etc. Obviously it is possible to do this
  manually with LaTeX commands but it can be extremely obnoxious if you
  have to use those macros very frequently.
* There are often multiple competing transcription schemes for each
  language and the author may not always be free in their choice of scheme.
  So I might write one article using scheme x, but I end up publishing it
  in a different paper than anticipated and that paper requires me to use
  scheme y. So I would essentially have to manually find every single
  instance of me using x and change it to y instead. Obviously this is
  both tedious and highly error-prone.

The Transconv package for LuaTeX aims to solve these problems by:

* letting the user write in a transcription scheme which is easier to
  input and have the package handle the conversion to the actual output scheme
  with diacritics etc., and
* abstracting the actual scheme itself away from the text, so the user can
  switch schemes by simply changing an option, not every instance of them
  using the scheme.

For instance, if I had to transcribe the Southern Min word for “fifteen”
in the Tâi-lô scheme (tsa&#x030D;p-gōo), I would normally have to write:

```latex
ts\textvbaraccent{a}p-g\={o}o
```

But Transconv allows me to simply use numbers instead of the tone
diacritics and write:

```latex
\tonan{tsap8-goo7}
```

What's more, if I suddenly find myself having to use the POJ transcription
scheme instead, all I have to do is change a package option and recompile, and
Transconv will output the correct POJ version instead: cha&#x030D;p-gō&#x0358;.
Or maybe I'm required to use Bbánlám pìngyīm? No problem:
zápggoô.

Also as you can see, Transconv has no problem switching back and forth
between multiple different schemes, either, if that is what you need.

## Currently Supported Languages

<table>
  <thead>
    <tr>
      <th>Abbreviation</th>
      <th>Language</th>
      <th>Input Scheme</th>
      <th>Supported Output Schemes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="2"><code>cmn</code></td>
      <td rowspan="2">Standard Chinese</td>
      <td rowspan="2">modified Pinyin</td>
      <td>Hanyu Pinyin (<code>cmn.pinyin</code>)</td>
    </tr>
    <tr>
      <td>Wade-Giles (<code>cmn.wadegiles</code>)</td>
    </tr>
    <tr>
      <td rowspan="3"><code>jap</code></td>
      <td rowspan="3">Standard Japanese</td>
      <td rowspan="3">modified Hepburn</td>
      <td>Hepburn (<code>jap.hepburn</code>)</td>
    </tr>
    <tr>
      <td>Kunrei-shiki (<code>jap.kunrei</code>)</td>
    </tr>
    <tr>
      <td>Nihon-shiki (<code>jap.nihon</code>)</td>
    </tr>
    <tr>
      <td rowspan="1"><code>kor</code></td>
      <td rowspan="1">Standard Korean</td>
      <td rowspan="1">modified Revised</td>
      <td>Revised Romanisation (<code>kor.revised</code>)</td>
    </tr>
    <tr>
      <td rowspan="4"><code>nan</code></td>
      <td rowspan="4">Hokkien/Southern Min</td>
      <td rowspan="4">modified Tâi-lô</td>
      <td>Bbánlám pìngyīm (<code>nan.bp</code>)</td>
    </tr>
    <tr>
      <td>POJ (<code>nan.poj</code>)</td>
    </tr>
    <tr>
      <td>Tâi-lô (<code>nan.tailo</code>)</td>
    </tr>
    <tr>
      <td>TLPA (<code>nan.tlpa</code>)</td>
    </tr>
  </tbody>
</table>

## Adding New Schemes or Languages

## Installation

Transconv uses Lua code for the conversion, so it will only work with LuaTeX!

In order to be able to use Transconv, you need to copy the `transconv.sty` file as
well as the `transconv/` directory (found inside `lua/`) to a place where
LuaTeX can find them. The suggested location for the `sty` file is within
`tex/latex/local/` in your local `texmf/` directory (typically found within your
home directory).

The `transconv/` folder can be placed in any directory in your kpathsea path.
You can check that path with the following console command:

```bash
kpsewhich --show-path=lua
```

The suggested location is within `scripts/` inside your local `texmf/`
directory. Assuming your local `texmf/` directory is located under that name in
your home directory, you can simply execute `make install` from the repository’s
top directory (the one containing `transconv.sty`).

If for some reason, you cannot get LuaTeX to find the module, you can consider
using the <a
href="https://www.ctan.org/pkg/luapackageloader">luapackageloader</a> package to
manually modify the path.

## Uninstallation

To uninstall Transconv, locate the `transconv.sty` file as well as the
`transconv/` lua package folder and delete them. Assuming they are located in
the recommended locations, you can simply run make uninstall from the top
directory (the one containing `transconv.sty`).
