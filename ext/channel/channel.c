#include "ruby.h"

typedef struct {
	int size;
	int sbs;
    VALUE *subscribers;
} RChannel;

#define MAX_CHANNEL_SIZE 32
#define GetChannelStruct(obj)	(Check_Type(obj, T_DATA), (RChannel*)DATA_PTR(obj))

VALUE rb_cChannel;
static ID id_call;

static void mark_channel(RChannel* ch)
{
    int i;
    for (i=0; i < ch->sbs; i++) {
      rb_gc_mark(ch->subscribers[i]);
    }
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
    chs->sbs = 0;
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

static VALUE 
rb_channel_subscribers( VALUE ch )
{
    RChannel* chs = GetChannelStruct(ch);    
    return INT2FIX(chs->sbs); 
}

static VALUE 
rb_channel_subscribe( int argc, VALUE *argv, VALUE ch )
{
    VALUE cb;
    RChannel* chs = GetChannelStruct(ch);    
    if (!rb_block_given_p()) rb_raise(rb_eArgError, "Block callback required!");
	if (chs->sbs == chs->size) rb_raise(rb_eArgError, "Maximum number of subscribers exceeded!");
    cb = rb_block_proc();
    chs->subscribers[chs->sbs] = cb;
    chs->sbs++;
    return ch;
}

static VALUE 
rb_channel_push( VALUE ch, VALUE obj )
{
    int i;
    RChannel* chs = GetChannelStruct(ch);    
    for (i=0; i < chs->sbs; i++) {
      rb_funcall(chs->subscribers[i],id_call,1,obj);
    }
    return ch;
}

void
Init_channel()
{ 
    id_call = rb_intern("call");

    rb_cChannel  = rb_define_class("Channel", rb_cObject);
    rb_define_alloc_func(rb_cChannel, channel_alloc);
    
    rb_define_method(rb_cChannel,"initialize", rb_channel_initialize, -1);
    rb_define_method(rb_cChannel,"size", rb_channel_size, 0);
    rb_define_method(rb_cChannel,"subscribers", rb_channel_subscribers, 0);
    rb_define_method(rb_cChannel,"subscribe", rb_channel_subscribe, -1);
    rb_define_method(rb_cChannel,"<<", rb_channel_push, 1);
}