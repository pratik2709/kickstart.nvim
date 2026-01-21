cltr + r: redo`


Neovim shortcuts learnt:

% find matching brackets
cltr + w: switch between panes
cltr + w + |: resize
:bd : close a buffer

cltr + d: exit terminal
:vs   splitting vertical



space f b - open buffer
space f f - full file search
cltr n - tree navigation
a - create new file
space rn - realtive line numbers
space h- horizontal terminal window
space v - vertical terminal window

cltr + 0 : begining of the line

yy - duplicate line
cltr + w : Switch terminal
cltr + / && cltr + n:  switch between terminala and buffer

Disable auto complete:
:lua require('cmp').setup.buffer { enabled = false }

# use cltr + w plus arrow keys to move around

use mv command to rename a file ?

apparently its ctrl-w and then + - < or > and the arrows work but plus and minus just change lines.


cltr + o/i => forward/backward
$ => jump to end of line

:term <command> - to run commands
:e reload buffer

space + x: close tab


:terminal to opena terminal

select a word/line/sentence:
vis - sentence
viw - word
viW - will select a word like motion.data

Goto references:
gr 

Split terminal verically:
cltr + W v

Compare two files:
first split them with above command
Then do:
:windo diffthis

All changed files in the git repo
:DiffviewOpen

Git history:
:DiffviewFileHistory 
:DiffviewFileHistory  %  - for current file

Navigate changes:
]c
c]

Accept changes from right to left
dp

Compare current branch with another branch
DiffviewOpen <name of the branch to compare>


Navigate front and back word by word:
w
b

Rename a file
r

Look through all open buffers:
space space

close buffer
:bd


Accept suggestion:
cltr + y


Import package:
gra

Reload buffer:
:e!

Captial V
V select whole line

Comment out multiple lines:
gc


how to reverse search 
? <search term>
Use n to move back

Goto line number:
:42

(requires gh installed)
Get PRs:
op

Open PR and then do od - to open in diff view

Diffview:
zo - open under cursoe 
zc - close under cursor
