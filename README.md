# ArcaneDepths

check https://arcane-depths.fly.dev/ to see it in action.

## Deployment

This is a game that combines the slow gameplay and simple graphics of dungeon
master for the amiga / ataris st with mulitplayer elements seen in escape from
tarkov or darkest dungeon. the player can assemble a party of characters they
have in their roster, equip them with gear and go in a raid. there are other
players in the raid (PvP) and also computer controlled enemies (PvE). there are
also bosses in the raid. the goal is to gather loot and experience and
successfully exiting the dungeon alive. in this case the player gets to keep all
loot and experience. in case of premature death of the party the player will
only get to keep a small part of the loot and the characters of the party are
gone. the player can of course recruit new characters (maybe the same way hunt
showdown does it).

## software
the game should be browser based. running in the elixir phoenix webserver. i
choose it because for one i really like the technology and the responsive
websites that can be created with liveview technology.

## software / game engine
the game graphics / mechnics work the way the old dungeon master. there is a
grid based movement that restricts the player / party of chars to move one tile
at a time and only turn in 4 directions. the viewport is done by and dynamic svg
image. this will be updated by liveview websockets. this way only the parts of
the image that need to be changed will be changed. another advantage of this
approach is that players will only have the data in their browser that they are
allowed to see, so no wallhax.

### software / game engine / graphics
the game is rendered in 2.5D, there is only fixed viewpoints into the world so
there shouldn't be too much 3d calculations going on. the complex part will be
to determine what each player should be able to see. this will prove especially
tricky with doors that can be open or not.

### software / game engine / gui
the gui should also work mostly like the original.

the gui consists of an upper area where the character portraits and their healthbars etc. are shown.
below that is the viewport into the dungeon.
right of that is an area that spans the height whole height.
it consists of three areas. upmost the chrachter placment, a square area with 2x2 divs.
below that the magic spell area, a rectanglar area. and below that the navigation.
it consists of a wasd style arrow pad with turn left and turn right in the upleft and upright boxes,
where q and e would be.

### software / game engine / dungeon

i want to use elixir absynthe to manage a datastructure of a dungeon that consists of multiple layers.
the layers consist of a 2d grid of cells.

this is the structure it should go into. the projects name is ArcaneDepthsWeb
├── graphql
│   ├── resolvers
│   │   └── dungeon_resolver.ex
│   ├── schema.ex
│   ├── schemas
│   │   ├── mutations
│   │       └── dungeon.ex
│   │   └── queries
│   │       └── dungeon.ex
│   └── types
│       └── dungeon.ex

one dungeon consists of multiple levels. each level consists of a 2d grid of cells. each cell has 4 walls that can each be of various types. types of cells can be normal, gate, staircase etc. . each cell has a ceiling that has a type like normal, trapdoor, etc. . each cell has a floor that has a type like normal, puddle, trapdoor etc. . the types of walls, floors and ceilings can change their look and behavoir. each of them can hold additional information like trapdoors and staircases have to know which level and position they lead to. each floor has 4 slots. each slot holds a list of items. the list is ordered and determines which item is rendered first. i need an elixir and ecto datastructure for that. each cell can contain one party. a party consists of 1 - 4 characters. each character has to stand on exactly one slot of the cell. i want to use elixir and absinthe graphql for this.

i'm wondering how we would make the "  the slots also can hold a monster or a player.
  these have to be part of the party that is currently standing in the cell." part happen. this would have to take into account the cell which has a party standing in it and the slot which has a character from that party in it.

i also need a party that can be inside a dungeon and on a specific cell.
the party can consist of 1-4 characters. these characters have to stand on one specific slot each.

Absinthe.Schema.lookup_type(ArcaneDepthsWeb.GraphQL.Schema, "Dungeon")

[
  %{
    cells: [
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "001",
        walls: [
          %{
            direction: "east",
            id: "2aba2ff6-2dbe-46b1-9ef7-4ba8dcb17dba",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "002",
        walls: [
          %{
            direction: "north",
            id: "690b27aa-0c5b-41b2-a38b-ac13c8af0677",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "003",
        walls: [
          %{
            direction: "north",
            id: "59173d1f-2698-4295-b44b-ff9ded81a18c",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "004",
        walls: [
          %{
            direction: "north",
            id: "89e863ed-7d5f-46f5-bf9b-49c9dd49947c",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "005",
        walls: [
          %{
            direction: "west",
            id: "ce9623f0-57a2-4be1-ad32-696ed4d7fb79",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "006",
        walls: [
          %{
            direction: "east",
            id: "cd7e8756-f446-41f6-b935-889cfd1cf24a",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "007",
        walls: []
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "008",
        walls: []
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "009",
        walls: []
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "010",
        walls: [
          %{
            direction: "west",
            id: "fe481607-c335-48ef-b5c7-cd13c9c76b31",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "011",
        walls: [
          %{
            direction: "east",
            id: "51f187e1-aecb-43e2-8aa2-66d63fa1915c",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "012",
        walls: []
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "013",
        walls: []
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "014",
        walls: []
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "015",
        walls: [
          %{
            direction: "west",
            id: "f712fe00-466a-463e-95a5-5cf172fe0558",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "016",
        walls: [
          %{
            direction: "east",
            id: "9c29e0b0-2427-4243-ab89-5ef85ab0b94b",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "017",
        walls: []
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "018",
        walls: []
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "019",
        walls: []
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "020",
        walls: [
          %{
            direction: "west",
            id: "f1b46491-1a0f-46a3-929c-da236693d21c",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "021",
        walls: [
          %{
            direction: "east",
            id: "c91e51a8-bb2a-4c7f-b715-e469bd124796",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "022",
        walls: [
          %{
            direction: "south",
            id: "142f05ae-c803-43da-a45e-500f0ad7a78d",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "023",
        walls: [
          %{
            direction: "south",
            id: "e0f91fba-cc27-4434-a4d4-c3c6277d8f10",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "024",
        walls: [
          %{
            direction: "south",
            id: "a297498b-ce2e-4acc-9bb2-f0a3c7bac2d9",
            type: "solid"
          }
        ]
      },
      %{
        floor: %{
          id: "001",
          slot_1: [],
          slot_2: [],
          slot_3: [],
          slot_4: [],
          type: :normal
        },
        id: "025",
        walls: [
          %{
            direction: "west",
            id: "e7ce7a2f-91af-441b-8357-73db82d8616d",
            type: "solid"
          }
        ]
      }
    ],
    id: "001"
  }
]


## game
gameplay should be very much the same as in dungeon master. the player moves on
step at a time in the directions north, east, south and west. they can also turn
the party in those direction. the goal is to explore the current dungeon, fight
mobs, gain experience and of course gather precious loot. there will be multiple
levels that are accessible by stairs. in the end there usually is a boss
waiting. maybe there are sidebosses too. players may also encouter other players
and have to choose how to interact with them fight or cooperate, maybe even
betray them.

## game / party
the party can consist of max 4 characters. they will always have a
relative placement in the party like the original. this will have certain
implications. if a character is standing directly next to an enemy they can
be hit with melee but also hit back. this is not possible if another char is
standing between the char and the enemy.
parties don't have to be 4 chars, players can also choose to take less chars.
this will have pros and cons. a single char also gains all the experience from
fighting. but they will also have to suffer all damage that is dealt to the party.

### game / perks
the ability to see further is bound to the characters you bring into the dungeon. when a character can see far into the dungeon they will spot enemies earlier. this will be represented as the game showing this enemy or not.

## game / enemies
the mobs orient on the original dungeon master but there will be some additions.
but the blue guys will make an appearence as well as the green mushroom tree
things. they will of course drop loot.

## game / enemies / bosses
the bosses should be more complex than in the original. they should have
multiple phases and maybe some gimmicks that will make the fight more
interesting.

## game / inventory
the inventory is organized in a 1d list instead of the more common 2d grid. this
prevents the tarkov tetris when players find new loot. it just becomes part of
the list when picked up. the size of the item is determined by weight and size.

## game / inventory / equipload
there is a maximum equipload that can be overshot, but then the character can't
move fast any more and will lose stamina. since the party can only walk as fast
as their slowest character this will slow down the whole party / player. if the
overweight player is loaded even more the char will take damage up to a point
where they may die. before the max equipload is reached there will be some
penalty for loading a char, much like the fatroll mechanic in darksouls.

## game / inventory / safe container
the first part of the list is a kind of safe container. if an item is inside
this part it will be safe even if the party wipes. there may be a situation
where the item reaches out of the container in which case there is a probability
for the item to be lost based on the amount of overhang. if a player find a
valuable item there is an easy way to put it on to of the inventory making it
part of the safe container. on a technical level the walking speed is managed by
the frequency the player can move forward a step. like in tarkov there may be
items that can't go into the safe container. in this case the item is put at the
start of the normal inventory section or, if there is something overhanging,
under that item.

```
+---x------------+
|  meds |  safe  |
+---x------------+
|   x   | normal |
|   |   |        |
| armor |        |
|   |   |        |
+---|---|-----=--+
|   x   |  over  |
|       |        |
+----------------+
```

## game / inventory / normal containers.
there is also the possibility to carry bags or chests. this will expand the
inventory with another 1d list next to the normal one. bags will be light weigth
but don't carry that much while chests can be very large but are also very heavy
themselves taking away space in the chars normal inventory or even preventing
them from carriing it in the first place. containers can also be checked and
looted without picking them out

## game / fighting
the fight system should be the same as in the original, but there will be
keyboard shortcuts to make the gameplay more efficient. melee with the usual
weapons swords, axes, etc..

## game / magic
i really like the magic system in the original and would like to keep it but
it's rather complex. so i will need to find a way to make it easier but also
keep the essence of it. this will also be usable by keyboard shortcuts, so a
practiced player can shoot fireballs with a few button pressed.

## game / magic / spells
like in the original magic spell have to be composed of different symbols.
Dungeon Master is a classic dungeon-crawling RPG game that was released on
various platforms in the late 1980s and early 1990s, including the Amiga. The
game's spell system was unique and involved the use of runes to create spells
with different effects.
The spells in Dungeon Master are made up of between two and four syllables,
which are represented by different runes. The first syllable or rune determines
the power of the spell, which affects the strength, duration, and mana cost of
the spell. The more powerful the spell, the more mana it requires to cast.
The second syllable or rune represents the elemental influence of the spell.
This can be one of several elements, such as fire, ice, or lightning, and
determines the type of damage the spell will deal.
The third syllable or rune represents the form of the spell. This can be one of
several forms, such as a bolt or a ball, and determines the way the spell is
cast. Not all spells use the third syllable, however.
The fourth and final syllable or rune represents the class or alignment of the
spell. This can be one of several types, such as chaos, order, or neutral, and
determines the overall nature of the spell. Again, not all spells use the fourth
syllable.
i'm not sure if i want to use it as is, but the idea should be the same. to
access the different runes there will be keyboard shortcuts to enable
experienced players to cast spells quickly and repeatedly. in the original you
would preload the magic spell bar because clicking it all together during battle
was stressfull.

By combining different runes in various ways, players can create a wide variety
of spells with different effects. The spell system in Dungeon Master was complex
but allowed for a great deal of creativity and experimentation, and is still
remembered fondly by many players today.

## game / magic / potions
there will also be potions in the game. i want the glass flasks to feel precious
like in the original. players find them rarely but they are very valuable since
they allow players to heal and refresh stats like stamina and mana. this would
be a prime item to put in your secure container because loosing it would really
hurt.

## game / crafting
this aspect will be borrowed more from minecraft. it is related to the magic
potion system but works without magic. this could be preparing meals to make
raw food into something more nutritious. or making coffee to regain some of the
stamina back. temperature will play a role here i.e. coffee might become cold
over time and then can't be consumed or make a char unhappy instead of raising
their stamina.
like in the original every char has two hands that will be important for the
crafting recepie they are doing. if a coffee has to be made there should be some
coffeebeans and a flask in the hands to work successfully. there may be characters
who have a trait of a missing or very weak hand.

## game / sleep
there will be the element of sleep in the game. in the original this would make
the screen black but keep the game running so that enemies can attack the party
at all times. this will be the same although the sleep can't be that long since
we have a multiplayer game. i also had the idea to make single characters sleep.
this would not make the screen black but prevent the party from moving.
maintenance on party related things would still be possible. i also thought
about a way characters could make coffee by extending the magic / crafting
system of the original. if a char has zero stamina they will also fall asleep
instantly with all consequences.

## game / trading
there will be in game merchant that sell different kinds of material. like a
smith who sells weapons, a herbal master who sells obviously herbals but also
can train the magic spells and sell the accessories that are involved with that.
there will also be a market place where players can sell other players items.

## game / multiplayer
the game will relie heavily on multiplayer to create a fun experience. players
have to choose if they want to fight or cooperate with others. the gameplay
with keyboard shortcuts will enable fast paced gameplay but the grid like pattern
also adds an strategic chess like character to it.
knowing the abilities of your sorcerers and the magic spells well will enable
you to dominate other players in the small hallways of the dungeon.
players can of course also cooperate and fight mobs together splitting the loot.
but players can also betray each other. if a char of a player dies the body of
that char can be looted by the player themself or other players.

## game / multiplayer / communications
players are able to communicate with each other. this is very important to
make cooperation possible. the main ways the game offers are chat and a
dark souls like graffiti system that enables players to leave messages for other
players. there will be no voip for now since thats hard to set up and even harder
to moderate and keep safe for all players. the chat will have some profanity
filter although this will not prevent all harassment and what have you, so
there will be an option to mute all chat or specific players. if players want
voip they can always set up a discord or some other service to talk to each other.
