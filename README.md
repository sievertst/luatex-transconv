# The Transconv package for LuaTeX

The Transconv package for LuaTeX aims to make the use of transcriptions in LaTeX
easier.

As it is, there are two main problems concerning transcriptions:

1. The transcription scheme of choice might be annoying to input (requiring the
   frequent use of macros to input characters which might not be accessible on
   the keyboard), and
2. There are often multiple competing schemes for the same language, so an
   author who was originally using scheme x might find themselves having to
   switch to scheme y. In practice this amounts to manually track down and
   change every place where x was used – which of course is both tedious and
   error-prone.

Transconv solves these problems by:

* letting the user write in a transcription scheme which is easier to
  input (normally pure ASCII) and have the package handle the conversion to the
  actual output scheme with diacritics etc., and
* abstracting the actual scheme itself away from the text. This allows the user
  to switch schemes by simply changing an option.

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

What's more, if I suddenly find myself having to use the Bbánlám pìngyīm transcription
scheme instead, all I have to do is change a package option and recompile, and
Transconv will output the correct Bbánlám pìngyīm version instead: zápggoô.

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
      <td rowspan="2"><code>kor</code></td>
      <td rowspan="2">Standard Korean</td>
      <td rowspan="2">modified Revised</td>
      <td>McCune-Reischauer (<code>kor.mcr</code>)</td>
    </tr>
    <tr>
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

It is also possible to add more languages and schemes with just a limited amount
of work.

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
your home directory, you can simply execute the following command from the
repository’s top directory (the one containing `transconv.sty`).

```bash
make install
```

If for some reason, you cannot get LuaTeX to find the module, you can consider
using the <a
href="https://www.ctan.org/pkg/luapackageloader">luapackageloader</a> package to
manually modify the path.

## Uninstallation

To uninstall Transconv, locate the `transconv.sty` file as well as the
`transconv/` lua package folder and delete them. Assuming they are located in
the recommended locations, you can simply run the following command from the top
directory (the one containing `transconv.sty`).

```bash
make uninstall
```
