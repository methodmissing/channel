#include "ruby.h"

typedef struct {
	int size;
    VALUE *subscribers;
} RChannel;

#define MAX_CHANNEL_SIZE 32
#define GetChannelStruct(obj)	(Check_Type(obj, T_DATA), (RChannel*)DATA_PTR(obj))

VALUE rb_cChannel;

static void mark_channel(RChannel* ch)
{
    rb_gc_mark(ch->subscribers);
}

static void free_channel(RChannel* ch)
{
    xfree(ch);
}

static VALUE channel_alloc _((VALUE));
static VALUE
channel_alloc( VALUE klass )
{
	VALUE ch;
	RChannel* chs;
	ch = Data_Make_Struct(klass, RChannel, mark_channel, free_channel, chs);
	chs->size = 0;
	chs->subscribers = 0;
	
    return ch;
}

static VALUE
rb_channel_new(VALUE ch, int size)
{
    RChannel* chs = GetChannelStruct(ch);
    if (size < 0 || size > MAX_CHANNEL_SIZE){ 
	  rb_raise(rb_eArgError, "Invalid channel size!");
    }
    if (size == 0) size++;
	chs->size = size;
    chs->subscribers = ALLOC_N(VALUE, size);
	return ch;  
}

static VALUE 
rb_channel_initialize( int argc, VALUE *argv, VALUE ch )
{
	VALUE size;
	int channel_size;
    RChannel* chs = GetChannelStruct(ch);    
    rb_scan_args(argc, argv, "01", &size);
	channel_size = NIL_P(size) ? 0 : FIX2INT(size);
	return rb_channel_new(ch, channel_size); 
}

static VALUE 
rb_channel_size( VALUE ch )
{
    RChannel* chs = GetChannelStruct(ch);    
	return INT2FIX(chs->size); 
}

void
Init_channel()
{ 
    rb_cChannel  = rb_define_class("Channel", rb_cObject);
    rb_define_alloc_func(rb_cChannel, channel_alloc);
    
    rb_define_method(rb_cChannel,"initialize", rb_channel_initialize, -1);
    rb_define_method(rb_cChannel,"size", rb_channel_size, 0);
}