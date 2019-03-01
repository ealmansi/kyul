→ solc --yul p1.yul 
> Error: Object name cannot be empty.
Grammar allows it.

→ solc --yul p1.yul 
> Object name cannot be the same as the name of the containing object.
Grammar allows it.

→ solc --yul p1.yul 
> p1.yul:8:10: Error: Object name cannot be empty.
>    data "" ""
Grammar allows it.
Also, why does it say "object name" if it's a data construct?


→ solc --yul p1.yul 
> p1.yul:36:10: Error: Object name "d" already exists inside the containing object.
>    data "d" ""
>         ^-^
