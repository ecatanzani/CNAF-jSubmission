CC=gcc
CXX=g++
RM=rm -f

SRCS=create_list.cpp
OBJS=$(subst .cpp,.o,$(SRCS))

all: create_list

create_list: $(OBJS)
	$(CXX) -o create_list $(OBJS) 

depend: .depend

.depend: $(SRCS)
	$(RM) ./.depend
	$(CXX) $(CPPFLAGS) -MM $^>>./.depend;

clean:
	$(RM) $(OBJS)

distclean: clean
	$(RM) *~ .depend

include .depend
