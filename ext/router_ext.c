#include "ruby.h"

VALUE router_ext_walk(VALUE self, VALUE segments, VALUE position) {
	if (!rb_funcall(self, rb_intern("frozen?"), 0))
		rb_raise(rb_eRuntimeError, "Can not traverse unfrozen Segment");

	int position_i = NUM2INT(position);
	VALUE segment = rb_ary_entry(segments, position_i);

	VALUE children = rb_iv_get(self, "@children");
	int children_len = RARRAY(children)->len;
	VALUE *children_ptr = RARRAY(children)->ptr;

	int i;
	for (i = 0; i < children_len; i++) {
		VALUE child = children_ptr[i];
		VALUE match_argv[] = {segment};
		VALUE matched = rb_funcall2(child, rb_intern("=~"), 1, match_argv);

		if (matched == Qtrue) {
			VALUE new_position = INT2NUM(position_i + 1);
			VALUE walk_argv[] = {segments, new_position};
			VALUE route = rb_funcall2(child, rb_intern("walk"), 2, walk_argv);

			if (route != Qnil)
				return route;
		}
	}

	return Qnil;
}

VALUE router_ext = Qnil;

void Init_router_ext() {
	router_ext = rb_define_module("RouterExt");
	rb_define_method(router_ext, "walk", router_ext_walk, 2);
}
