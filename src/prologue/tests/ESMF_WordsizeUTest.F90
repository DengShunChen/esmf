! $Id$
!
! Earth System Modeling Framework
! Copyright 2002-2022, University Corporation for Atmospheric Research,
! Massachusetts Institute of Technology, Geophysical Fluid Dynamics
! Laboratory, University of Michigan, National Centers for Environmental
! Prediction, Los Alamos National Laboratory, Argonne National Laboratory,
! NASA Goddard Space Flight Center.
! Licensed under the University of Illinois-NCSA License.
!
!==============================================================================

    program WordsizeTest
    
#include "ESMF.h"
    use iso_c_binding

    use ESMF
    use ESMF_TestMod
    implicit none

    integer :: rc, result
    character(len=ESMF_MAXSTR) :: failMsg, name
    integer(kind=C_SIZE_T) :: c_ptrvar
    integer :: diff
    integer :: i1sizeF, i2sizeF, i4sizeF, i8sizeF, r4sizeF, r8sizeF, ptrsizeF
    integer :: i1sizeC, i2sizeC, i4sizeC, i8sizeC, r4sizeC, r8sizeC, ptrsizeC

    ! create array of pointers
    type testp 
    sequence
        integer, pointer :: fredp
    end type
    type(testp)           :: vip(2)

    ! create arrays of integer and real kinds
    integer               :: vi(2)
    real                  :: vr(2)

#ifndef ESMF_NO_INTEGER_1_BYTE 
    integer(ESMF_KIND_I1) :: vi1(2)
#endif
#ifndef ESMF_NO_INTEGER_2_BYTE 
    integer(ESMF_KIND_I2) :: vi2(2)
#endif
    integer(ESMF_KIND_I4) :: vi4(2)
    integer(ESMF_KIND_I8) :: vi8(2)
    real(ESMF_KIND_R4)    :: vr4(2)
    real(ESMF_KIND_R8)    :: vr8(2)

#if defined (ESMF_NO_C_SIZEOF)
#define C_SIZEOF(x) size(transfer(x,sizeof_data))
    character :: sizeof_data(32)
#endif


!------------------------------------------------------------------------
! test of default variable wordsizes, selected_int_kind options, pointer
! sizes - both for single languages and interlanguage.

    result = 0

    call ESMF_TestStart(ESMF_SRCLINE, rc=rc)
    if (rc /= ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)

    !------------------------------------------------------------------------
    !------------------------------------------------------------------------
    ! not a test - informational messages only.
    call ESMF_PointerDifference(C_SIZEOF (c_ptrvar), vi(1), vi(2), diff)
    print *, "F90: Default Integer size = ", diff

    call ESMF_PointerDifference(C_SIZEOF (c_ptrvar), vr(1), vr(2), diff)
    print *, "F90: Default Real size = ", diff


    !------------------------------------------------------------------------
    !------------------------------------------------------------------------
    ! Collect sizes on the Fortran side.

    call ESMF_PointerDifference(C_SIZEOF (c_ptrvar), vip(1), vip(2), ptrsizeF)
    print *, "F90: Pointer size = ", ptrsizeF

#ifndef ESMF_NO_INTEGER_1_BYTE
    call ESMF_PointerDifference(C_SIZEOF (c_ptrvar), vi1(1), vi1(2), i1sizeF)
    print *, "F90: Explicit Integer I1 size = ", i1sizeF
#endif

#ifndef ESMF_NO_INTEGER_2_BYTE
    call ESMF_PointerDifference(C_SIZEOF (c_ptrvar), vi2(1), vi2(2), i2sizeF)
    print *, "F90: Explicit Integer I2 size = ", i2sizeF
#endif

    call ESMF_PointerDifference(C_SIZEOF (c_ptrvar), vi4(1), vi4(2), i4sizeF)
    print *, "F90: Explicit Integer I4 size = ", i4sizeF

    call ESMF_PointerDifference(C_SIZEOF (c_ptrvar), vi8(1), vi8(2), i8sizeF)
    print *, "F90: Explicit Integer I8 size = ", i8sizeF

    call ESMF_PointerDifference(C_SIZEOF (c_ptrvar), vr4(1), vr4(2), r4sizeF)
    print *, "F90: Explicit Real R4 size = ", r4sizeF

    call ESMF_PointerDifference(C_SIZEOF (c_ptrvar), vr8(1), vr8(2), r8sizeF)
    print *, "F90: Explicit Real R8 size = ", r8sizeF

    !------------------------------------------------------------------------
    !------------------------------------------------------------------------
    !NEX_UTest
    ! get numbers from C for next set of tests
    call c_ints(i1sizeC, i2sizeC, i4sizeC, i8sizeC, r4sizeC, r8sizeC, ptrsizeC, rc)
    write(failMsg,*) "Failed getting int/float/ptr sizes"
    write(name, *) "Getting C int/float word sizes"
    call ESMF_Test((rc .eq. ESMF_SUCCESS), name, failMsg, result, ESMF_SRCLINE) 

    !------------------------------------------------------------------------
    !------------------------------------------------------------------------
    ! Compare F90 and C++ sizes; they must match.
    !NEX_UTest
#ifndef ESMF_NO_INTEGER_1_BYTE
    write(failMsg,*) "Size mismatch for I1 variable: ", i1sizeC, " /=", i1sizeF
    write(name, *) "Verifying F90 I1 matches C I1"
    call ESMF_Test((i1sizeC .eq. i1sizeF), name, failMsg, result, ESMF_SRCLINE) 
#else
    write(failMsg,*) "Size mismatch for I1 variable"
    write(name, *) "Verifying F90 I1 matches C I1 - disabled"
    call ESMF_Test((0 .eq. 0), name, failMsg, result, ESMF_SRCLINE) 
#endif

    !------------------------------------------------------------------------
    !NEX_UTest
#ifndef ESMF_NO_INTEGER_2_BYTE
    write(failMsg,*) "Size mismatch for I2 variable: ", i2sizeC, " /=", i2sizeF
    write(name, *) "Verifying F90 I2 matches C I2"
    call ESMF_Test((i2sizeC .eq. i2sizeF), name, failMsg, result, ESMF_SRCLINE) 
#else
    write(failMsg,*) "Size mismatch for I2 variable"
    write(name, *) "Verifying F90 I2 matches C I2 - disabled"
    call ESMF_Test((0 .eq. 0), name, failMsg, result, ESMF_SRCLINE) 
#endif

    !------------------------------------------------------------------------
    !NEX_UTest
    write(failMsg,*) "Size mismatch for I4 variable: ", i4sizeC, " /=", i4sizeF
    write(name, *) "Verifying F90 I4 matches C I4"
    call ESMF_Test((i4sizeC .eq. i4sizeF), name, failMsg, result, ESMF_SRCLINE) 

    !------------------------------------------------------------------------
    !NEX_UTest
    write(failMsg,*) "Size mismatch for I8 variable: ", i8sizeC, " /=", i8sizeF
    write(name, *) "Verifying F90 I8 matches C I8"
    call ESMF_Test((i8sizeC .eq. i8sizeF), name, failMsg, result, ESMF_SRCLINE) 

    !------------------------------------------------------------------------
    !NEX_UTest
    write(failMsg,*) "Size mismatch for R4 variable: ", r4sizeC, " /=", r4sizeF
    write(name, *) "Verifying F90 R4 matches C R4"
    call ESMF_Test((r4sizeC .eq. r4sizeF), name, failMsg, result, ESMF_SRCLINE) 

    !------------------------------------------------------------------------
    !NEX_UTest
    write(failMsg,*) "Size mismatch for R8 variable: ", r8sizeC, " /=", r8sizeF
    write(name, *) "Verifying F90 R8 matches C R8"
    call ESMF_Test((r8sizeC .eq. r8sizeF), name, failMsg, result, ESMF_SRCLINE) 


    !------------------------------------------------------------------------
    !------------------------------------------------------------------------

#ifdef ESMF_TESTEXHAUSTIVE

    !------------------------------------------------------------------------
    !------------------------------------------------------------------------

    ! no exhaustive tests (yet)

    !------------------------------------------------------------------------
    !------------------------------------------------------------------------


#endif

    call ESMF_TestEnd(ESMF_SRCLINE)

    end program WordsizeTest
    
