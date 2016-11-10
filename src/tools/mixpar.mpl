head	1.1;
branch	1.1.1;
access;
symbols
	Rel-1-80-pre2-R6:1.1.1.1
	Rel-1-80-pre1-R6:1.1.1.1
	Rel-1-79:1.1.1.1
	Rel-1-79-R6:1.1.1.1
	Rel-1-79-pre5-R6:1.1.1.1
	Rel-1-79-pre4-R6:1.1.1.1
	Rel-1-79-pre3-R6:1.1.1.1
	Rel-1-79-pre3:1.1.1.1
	Rel-1-78:1.1.1.1
	Rel-1-78-R6:1.1.1.1
	Rel-1-79-pre1:1.1.1.1
	Rel-1-78-pre5-R6:1.1.1.1
	Rel-1-78-pre5:1.1.1.1
	Rel-1-78-pre4-R6:1.1.1.1
	Rel-1-78-pre4:1.1.1.1
	Rel-1-78-pre2-R6:1.1.1.1
	Rel-1-78-pre2:1.1.1.1
	Rel-1-78-pre1-R6:1.1.1.1
	Rel-1-78-pre1:1.1.1.1
	Rel-1-77:1.1.1.1
	R6:1.1.1.1.0.4
	Rel-1-77-R6:1.1.1.1
	Rel-1-77-pre1-R6:1.1.1.1
	Rel-1-77-pre1-R5:1.1.1.1
	Rel-1-76-R6:1.1.1.1.0.2
	Rel-1-75:1.1.1.1
	Rel-1-76:1.1.1.1
	Rel-1-76pre2:1.1.1.1
	Rel-1-74:1.1.1.1
	GRTensorII:1.1.1;
locks; strict;
comment	@# @;


1.1
date	99.08.17.12.49.42;	author dp;	state Exp;
branches
	1.1.1.1;
next	;

1.1.1.1
date	99.08.17.12.49.42;	author dp;	state Exp;
branches;
next	;


desc
@@



1.1
log
@Initial revision
@
text
@grmixpar := proc(expr)
local dd,expr2;
options `Copyright 1993 by Waterloo Maple Software - slight tweak by P. Musgrave`;
    if nargs <> 1 or not type(expr,{'algebraic','list','equation'}) then
        ERROR(`wrong number or type of arguments`)

    elif type(expr, 'equation') then
           grmixpar(lhs(expr)) = grmixpar(rhs(expr));

    elif not has(expr,diff) or expr = diff then expr

    elif type(expr,'function') then
        if op(0,expr) = diff then
            dd := op(2,expr);
            expr2 := op(1,expr);
            while type(expr2,'function') and op(0,expr2) = diff do
                dd := dd,op(2,expr2); expr2 := op(1,expr2)
            od;
            expr2 := grmixpar(expr2);
            diff (expr2, op(sort([dd],'lexorder')));
        else map(grmixpar,expr)
        fi
    else map(grmixpar,expr)
    fi
end:

@


1.1.1.1
log
@Initial import to CVS repository
@
text
@@
