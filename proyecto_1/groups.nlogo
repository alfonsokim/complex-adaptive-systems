turtles-own
[
  ;; a number representing the group this turtle is a member of, or -1 if this
  ;; turtle is not in a group.
  my-group
]

;;; ABOUT THE PROBLEM
;;;
;;; In some cases, you have a group of turtles that you wish to divide into
;;; groups of roughly the same size.
;;;
;;; Note that if you have a fixed number of groups known in advance, there are
;;; probably better ways to do this, using breeds, for instance. The
;;; techniques here are only necessary when you need to dynamically modify the
;;; size or number of the groups.
;;;
;;; Conceptually, there are two basic ways to form groups: by desired group
;;; size, or by desired number of groups. In either case, if the target number
;;; evenly divides the total number of turtles, there's no problem. But if it
;;; doesn't, then we have to make some decisions.
;;;
;;; When creating groups of a fixed size, say k, it's most natural to form as
;;; many groups of k turtles as possible, and then consider the remainder of
;;; the turtles "extra", and create one smaller group containing only those
;;; turtles. That way, all but one of the groups will have the desired size.
;;;
;;; When creating a fixed number of groups, it's most natural to assign one
;;; turtle to each group, and continue in this way until all turtles have been
;;; assigned. This, for instance, is the strategy one would most likely adopt
;;; in trying to distribute a large number of ping-pong balls as evenly as
;;; possible among a fixed number of buckets. In this case, all the groups
;;; will have either size k or size k + 1, for some k.
;;;
;;; The following two procedures implement each of these strategies. Which is
;;; appropriate for your model depends on your requirements. Other variations
;;; on these schemes are, of course, possible.



;;; this procedure randomly assigns turtles to groups based on the desired
;;; size of the groups. all the groups will have the desired size except for
;;; at most one group, which contains the remainder of the turtles. more
;;; formally, if there are n turtles, and the desired group size is k, this
;;; procedure will produce j = floor (n / k) groups of k turtles, and if
;;; n mod k > 0, it will produce one group of n mod k turtles.
to assign-by-size

  ;; all turtles are initially ungrouped
  ask turtles [ set my-group -1 ]
  let unassigned turtles

  ;; start with group 0 and loop to build each group
  let current 0
  while [any? unassigned]
  [
    ;; place a randomly chosen set of group-size turtles into the current
    ;; group. or, if there are less than group-size turtles left, place the
    ;; rest of the turtles in the current group.
    ask n-of (min (list group-size (count unassigned))) unassigned
      [ set my-group current ]
    ;; consider the next group.
    set current current + 1
    ;; remove grouped turtles from the pool of turtles to assign
    set unassigned unassigned with [my-group = -1]
  ]
end

;;; this procedure randomly assigns turtles to groups based on the desired
;;; number of groups. all the groups will have as close as possible to the
;;; same number of turtles. more formally, if there are n turtles, and the
;;; desired number of groups is j, then let the initial group size be
;;; k = ceiling (n / j). this procedure will produce n mod j groups of size
;;; k and j - (n mod j) groups of size k - 1.
to assign-by-number
  ;; figure out the larger of the two group sizes
  let tmp-group-size ceiling (count turtles / number-of-groups)

  ;; all turtles are initially ungrouped
  ask turtles [ set my-group -1 ]
  let unassigned turtles

  ;; start with group 0 and loop to build each group
  let current 0
  while [any? unassigned]
  [
    ;; place a randomly chosen set of tmp-group-size turtles into the current group
    ask n-of tmp-group-size unassigned
      [ set my-group current ]
    ;; consider the next group. if we're done building the larger groups,
    ;; reduce the group size by 1 for the rest of the groups.
    set current current + 1
    if current = ((count turtles) mod number-of-groups)
      [ set tmp-group-size tmp-group-size - 1 ]
    ;; remove grouped turtles from the pool of turtles to assign
    set unassigned unassigned with [my-group = -1]
  ]
end

;;;
;;; the following procedures are used to implement the visualization,
;;; and really don't have anything to do with grouping.
;;; unless you're particularly interested, it's safe to ignore the rest of the
;;; code.
;;;

;;; sets up the model
to setup
  clear-all
  crt number-of-turtles
  [
    ;; we want the color to be related to the who number of the turtles, so
    ;; that it will be fairly obvious if turtles are grouped in an ordered way.
    set color scale-color green who (number-of-turtles / -4)
                                    (number-of-turtles * 1.2)
    ;; randomly place them initially
    setxy random-xcor random-ycor
    ;; turtles start out ungrouped
    set my-group -1
  ]
  reset-ticks
end

;; causes the turtles to run around, going to their group's "home" if they're
;; in a group.
to go
  ask turtles
  [
    ;; if i'm in a group, move towards "home" for my group
    if my-group != -1
      [ face get-home ]
    ;; wiggle a little and always move forward, to make sure turtles don't all
    ;; pile up
    lt random 5
    rt random 5
    fd 1
  ]
  tick
end

;; figures out the home patch for a group. this looks complicated, but the
;; idea is simple. we just want to lay the groups out in a regular grid,
;; evenly spaced throughout the world. we want the grid to be square, so in
;; some cases not all the positions are filled.
to-report get-home ;; turtle procedure
  ;; calculate the minimum length of each side of our grid
  let side ceiling (sqrt (max [my-group] of turtles + 1))

  report patch
           ;; compute the x coordinate
           (round ((world-width / side) * (my-group mod side)
             + min-pxcor + int (world-width / (side * 2))))
           ;; compute the y coordinate
           (round ((world-height / side) * int (my-group / side)
             + min-pycor + int (world-height / (side * 2))))
end


; Public Domain:
; To the extent possible under law, Uri Wilensky has waived all
; copyright and related or neighboring rights to this model.