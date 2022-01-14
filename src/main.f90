!> 
!! Copyright 2016 ARC Centre of Excellence for Climate Systems Science
!!
!! \author  Scott Wales <scott.wales@unimelb.edu.au>
!!
!! Licensed under the Apache License, Version 2.0 (the "License");
!! you may not use this file except in compliance with the License.
!! You may obtain a copy of the License at
!!
!!     http://www.apache.org/licenses/LICENSE-2.0
!!
!! Unless required by applicable law or agreed to in writing, software
!! distributed under the License is distributed on an "AS IS" BASIS,
!! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!! See the License for the specific language governing permissions and
!! limitations under the License.

program example
    use callpy_mod
    implicit none
    
    real(8) :: a(10)
    a = 1.0
    call set_state("a", a)
    call call_function("builtins", "print")
    ! read any changes from "a" back into a.
    call get_state("a", a)
    
    end program example
