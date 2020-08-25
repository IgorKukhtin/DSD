{==============================================================================*
* Copyright © 2020, Pukhkiy Igor                                               *
* All rights reserved.                                                         *
*==============================================================================*
* This Source Code Form is subject to the terms of the Mozilla                 *
* Public License, v. 2.0. If a copy of the MPL was not distributed             *
* with this file, You can obtain one at http://mozilla.org/MPL/2.0/.           *
*==============================================================================*
* The Initial Developer of the Original Code is Pukhkiy Igor (Ukraine).        *
* Contacts: nspytnik-programming@yahoo.com                                     *
*==============================================================================*
* DESCRIPTION:                                                                 *
* MinJobs.pas - helper for run job and background task                         *
*                                                                              *
* Last modified: 02.06.2017 11:07:00                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit MinJobs;

interface
uses
  Windows;

type
  TIOCounters = record
      ReadOperationCount,
      WriteOperationCount,
      OtherOperationCount,
      ReadTransferCount,
      WriteTransferCount,
      OtherTransferCount: Int64;
  end;


  {$IFDEF CPUX64}
  TJobObjectBasicLimitInformation = record
    PerProcessUserTimeLimit: TLargeInteger;
    PerJobUserTimeLimit: TLargeInteger;
    LimitFlags: DWORD;
    MinimumWorkingSetSize,
    MaximumWorkingSetSize: SIZE_T;
    ActiveProcessLimit: DWORD;
    Affinity: ULONG_PTR;
    PriorityClass,
    SchedulingClass: DWORD;
  end;
  {$ELSE}

  TJobObjectBasicLimitInformation = packed record
    PerProcessUserTimeLimit: TLargeInteger;
    PerJobUserTimeLimit: TLargeInteger;
    LimitFlags,
    MinimumWorkingSetSize,
    MaximumWorkingSetSize,
    ActiveProcessLimit,
    Affinity,
    PriorityClass,
    SchedulingClass: DWORD;
  end;
  {$ENDIF}


  PJobObjectExtendedLimitInformation = ^TJobObjectExtendedLimitInformation;
  TJobObjectExtendedLimitInformation = record
      BasicLimitInformation: TJobObjectBasicLimitInformation;
      IoInfo: TIOCounters;
      ProcessMemoryLimit,
      JobMemoryLimit,
      PeakProcessMemoryUsed,
      PeakJobMemoryUsed: SIZE_T;
  end;

  TJobObjectInfoClass = (
    JobObjectBasicLimitInformation              = 2,
    JobObjectBasicUIRestrictions                = 4,
    JobObjectSecurityLimitInformation           = 5,
    JobObjectEndOfJobTimeInformation            = 6,
    JobObjectAssociateCompletionPortInformation = 7,
    JobObjectExtendedLimitInformation           = 9,
    JobObjectGroupInformation                   = 11,
    JobObjectNotificationLimitInformation       = 12,
    JobObjectGroupInformationEx                 = 14,
    JobObjectCpuRateControlInformation          = 15
  );

const
  JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE  = $00002000;
  CREATE_BREAKAWAY_FROM_JOB          = $01000000;

 function CreateJobObject(lpJobAttributes: PSecurityAttributes;
    lpName: LPCWSTR): THandle; stdcall; external kernel32 name 'CreateJobObjectW';
 function SetInformationJobObject(hJob: THandle;
    JobObjectInformationClass: TJobObjectInfoClass;
    lpJobObjectInformation: Pointer;
    cbJobObjectInformationLength: DWORD): BOOL; stdcall; external kernel32 Name 'SetInformationJobObject';
 function AssignProcessToJobObject(hJob, hProcess: THandle): BOOL; stdcall; external kernel32 name 'AssignProcessToJobObject';


implementation

end.
