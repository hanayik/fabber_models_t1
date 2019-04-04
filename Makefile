include ${FSLCONFDIR}/default.mk

PROJNAME = fabber_t1

USRINCFLAGS = -I${INC_NEWMAT} -I${INC_PROB} -I${INC_BOOST} -I..
USRLDFLAGS = -L${LIB_NEWMAT} -L${LIB_PROB} -L../fabber_core

FSLVERSION= $(shell cat ${FSLDIR}/etc/fslversion | head -c 1)
ifeq ($(FSLVERSION), 5) 
  NIFTILIB = -lfslio -lniftiio 
  LIB_NEWMAT = ${LIB_NEWMAT} -lnewmat
else 
  NIFTILIB = -lNewNifti
endif

LIBS = -lutils -lnewimage -lmiscmaths -lprob -L${LIB_NEWMAT} ${NIFTILIB} -lznz -lz -ldl

XFILES = fabber_t1

# Forward models
OBJS =  fwdmodel_vfa.o

# For debugging:
#OPTFLAGS = -ggdb

# Pass Git revision details
GIT_SHA1:=$(shell git describe --dirty)
GIT_DATE:=$(shell git log -1 --format=%ad --date=local)
CXXFLAGS += -DGIT_SHA1=\"${GIT_SHA1}\" -DGIT_DATE="\"${GIT_DATE}\""

#
# Build
#

all:	${XFILES} libfabber_models_t1.a

# models in a library
libfabber_models_t1.a : ${OBJS}
	${AR} -r $@ ${OBJS}

# fabber built from the FSL fabbercore library including the models specifieid in this project
fabber_t1 : fabber_client.o ${OBJS}
	${CXX} ${CXXFLAGS} ${LDFLAGS} -o $@ $< ${OBJS} -lfabbercore -lfabberexec ${LIBS}

# DO NOT DELETE
