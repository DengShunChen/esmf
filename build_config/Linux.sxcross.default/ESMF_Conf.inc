#if 0
$Id$

Earth System Modeling Framework
Copyright 2002-2022, University Corporation for Atmospheric Research,
Massachusetts Institute of Technology, Geophysical Fluid Dynamics
Laboratory, University of Michigan, National Centers for Environmental
Prediction, Los Alamos National Laboratory, Argonne National Laboratory,
NASA Goddard Space Flight Center.
Licensed under the University of Illinois-NCSA License.
#endif

#if 0
Define the proper way to flush Fortran units.  Typically this will
be one of the following:

  * Fortran-2003 FLUSH statement (preferred)
  * Two argument FLUSH call
  * One argument FLUSH call

#endif

#define ESMF_IOFlushMacro(unit,status) write (ESMF_IOstderr,*) "ESMF_IOFlushMacro: Unimplemented code"

#if 0
Define the proper way to read the command line.  Use getarg for now.

#endif

#define ESMF_NEEDSGETARG

#if 0
currently an empty file.  available if #defines needed
on a per-system basis for F90 code
#endif

