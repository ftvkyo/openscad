module repeat_row(step, count) {
    assert(is_list(step) && 2 <= len(step) && len(step) <= 3);
    for (comp = step) assert(is_num(comp));
    assert(is_num(count));

    for (i = [0 : count - 1])
    translate(step * i)
        children();
}


module arrange_row(step) {
    assert(is_list(step) && 2 <= len(step) && len(step) <= 3);
    for (comp = step) assert(is_num(comp));

    for (i = [0 : $children - 1])
    translate(step * i)
        children(i);
}
