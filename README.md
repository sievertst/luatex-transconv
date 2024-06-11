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

## Usage

Assuming you have all the files in a location where LuaTex can find them
(see [Installation](#installation)), you can set up Transconv for use in your
document like so:

```latex
\usepackage[scheme = cmn.pinyin]{transconv}
```

Or alternatively:

```latex
\usepackage{transconv}
\TransconvUseScheme{cmn.pinyin}
```

This sets your default output scheme for Standard Chinese (`cmn`) to Hanyu Pinyin:

```latex
\tocmn{Ni3 hao3.} % output: Nǐ hǎo.
```

You can also set up multiple languages, secondary schemes for the same language
(for example to compare them with each other in your text), and configure how
the output is typeset. Confer the documentation for this.

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
      <td><code>ara</code></td>
      <td>Arabic</td>
      <td>modified ArabTeX</td>
      <td>DIN 31635 (<code>ara.din</code>, WIP)</td>
    </tr>
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
      <td rowspan="3"><code>jpn</code></td>
      <td rowspan="3">Standard Japanese</td>
      <td rowspan="3">modified Hepburn</td>
      <td>Hepburn (<code>jpn.hepburn</code>)</td>
    </tr>
    <tr>
      <td>Kunrei-shiki (<code>jpn.kunrei</code>)</td>
    </tr>
    <tr>
      <td>Nihon-shiki (<code>jpn.nihon</code>)</td>
    </tr>
    <tr>
      <td rowspan="4"><code>kor</code></td>
      <td rowspan="4">Standard Korean</td>
      <td rowspan="4">modified Revised</td>
      <td>McCune-Reischauer (original) (<code>kor.mcr</code>)</td>
    </tr>
    <tr>
      <td>McCune-Reischauer (DPRK variant) (<code>kor.mcr-n</code>)</td>
    </tr>
    <tr>
      <td>McCune-Reischauer (ROK variant) (<code>kor.mcr-s</code>)</td>
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
  <tr>
    <td rowspan="1"><code>san</code></td>
    <td rowspan="1">Sanskrit</td>
    <td rowspan="1">modified Velthuis</td>
    <td rowspan="1">IAST (<code>san.iast</code>)</td>
  </tr>
  <tr>
    <td rowspan="1"><code>yue</code></td>
    <td rowspan="1">Cantonese</td>
    <td rowspan="1">modified jyutping</td>
    <td rowspan="1">Jyutping (<code>yue.jyutping</code>)</td>
  </tr>
</table>

It is also possible to add more languages and schemes with just a limited amount
of work.

## Installation

Transconv uses Lua code for the conversion, so it will only work with LuaTeX!

Nix users can add Transconv to the package list in their document flake like so:

```nix
{
  description = "My Transconv document";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    transconv-flake.url = "github:sievertst/luatex-transconv";
  };
  outputs = {self, nixpkgs, transconv-flake }:
    let
      # the name of your tex file without the extension      
      sourceName = "mydocument"; 

      system = "x86_64-linux"; # or whatever your system is
      pkgs = nixpkgs.legacyPackages.${system};
      transconv = transconv-flake.packages.${system}.default;
      tex = pkgs.texliveBasic.withPackages (_: [ transconv ] );
      buildInputs = [ pkgs.coreutils tex ];      
    in
    {
      packages.${system}.default = pkgs.stdenvNoCC.mkDerivation {
        pname = "transconv-document";
        version = "1.0";
        src = self;
        phases = [ "unpackPhase" "buildPhase" "installPhase" ];
        inherit buildInputs;
        buildPhase = ''
          export PATH="${pkgs.lib.makeBinPath buildInputs}";
          mkdir -p .cache/texmf-var;
          env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
            lualatex --interaction=nonstopmode ${sourceName}.tex;
        '';
        installPhase = ''
          mkdir -p $out
          cp ${sourceName}.pdf $out/
        '';
      };
    };
}
```

Non-Nix users need to copy the `transconv.sty` file as well as the `transconv/
` directory (found inside `lua/`) to a place where LuaTeX can find them. This
can simply be your document's root directory. If you want to install Transconv
system-wide, the suggested location for the `sty` file is within `tex/latex/
local/` in your local `texmf/` directory (typically found within your home
directory).

The `transconv/` folder can be placed in any directory in your kpathsea path.
You can check that path with the following console command:

```bash
kpsewhich --show-path=lua
```

The suggested location is within `scripts/kpsewhich/lua` inside your local `texmf/`
directory.

If for some reason, you cannot get LuaTeX to find the lua module,
you can consider using the
[luapackageloader](https://www.ctan.org/pkg/luapackageloader) package to
manually modify the path.

## Uninstallation

To uninstall Transconv, locate the `transconv.sty` file as well as the
`transconv/` lua package folder and delete them.
