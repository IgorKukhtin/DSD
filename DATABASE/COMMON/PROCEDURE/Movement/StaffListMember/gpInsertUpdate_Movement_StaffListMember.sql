-- Function: gpInsertUpdate_Movement_StaffListMember ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StaffListMember (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StaffListMember (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                               , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_StaffListMember(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMemberId            Integer   , -- 
    IN inPositionId          Integer   , --
    IN inPositionLevelId     Integer   , --
    IN inUnitId              Integer   , --
    IN inPositionId_old      Integer   , --
    IN inPositionLevelId_old Integer   , --
    IN inUnitId_old          Integer   , -- 
    IN inPersonalId_old      Integer   , --
    IN inReasonOutId         Integer   , --
    IN inStaffListKindId     Integer   , --

    IN inPersonalGroupId                   Integer   , -- ����������� �����������
    IN inPersonalServiceListId             Integer   , -- ��������� ����������(�������)
    IN inPersonalServiceListOfficialId     Integer   , -- ��������� ����������(��)
    IN inPersonalServiceListCardSecondId   Integer   , -- ��������� ����������(����� �2) 
    IN inPersonalServiceListId_AvanceF2    Integer   , --  ��������� ����������(����� ����� �2)
    IN inSheetWorkTimeId                   Integer   , -- ����� ������ (������ ������ �.��.)
    IN inStorageLineId_1                   Integer   , -- ������ �� ����� ������������
    IN inStorageLineId_2                   Integer   , -- ������ �� ����� ������������
    IN inStorageLineId_3                   Integer   , -- ������ �� ����� ������������
    IN inStorageLineId_4                   Integer   , -- ������ �� ����� ������������
    IN inStorageLineId_5                   Integer   , -- ������ �� ����� ������������
    IN inMember_ReferId                    Integer   , -- ������� �������������
    IN inMember_MentorId                   Integer   , -- ������� ���������� 	

    IN inisOfficial          Boolean   , --
    IN inisMain              Boolean   , --
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)     
                      
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId     Integer;
           vbPersonalId Integer;
           vbMovementId Integer;
           vbDateIn     TDateTime;
           vbDateOut    TDateTime;
           vbDateSend   TDateTime;
           vbIsDateOut  Boolean;
           vbIsDateSend Boolean;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_StaffListMember());
     vbUserId:= lpGetUserBySession (inSession);

     --��������
     IF COALESCE (inMemberId,0) = 0
     THEN
          RAISE EXCEPTION '������.<���. ����> ������ ���� ���������.';
     END IF;                                                  

     --�������� ���� �� ��� ����� ��������
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Member
                                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                                                        AND MovementLinkObject_Member.ObjectId = inMemberId
 
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                        AND MovementLinkObject_Unit.ObjectId = inUnitId
               
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Position
                                                         ON MovementLinkObject_Position.MovementId = Movement.Id
                                                        AND MovementLinkObject_Position.DescId = zc_MovementLinkObject_Position()
                                                        AND MovementLinkObject_Position.ObjectId = inPositionId
               
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PositionLevel
                                                        ON MovementLinkObject_PositionLevel.MovementId = Movement.Id
                                                       AND MovementLinkObject_PositionLevel.DescId = zc_MovementLinkObject_PositionLevel()
               
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_ReasonOut
                                                        ON MovementLinkObject_ReasonOut.MovementId = Movement.Id
                                                       AND MovementLinkObject_ReasonOut.DescId = zc_MovementLinkObject_ReasonOut()
               
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_StaffListKind
                                                        ON MovementLinkObject_StaffListKind.MovementId = Movement.Id
                                                       AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind()
                     
                      WHERE Movement.DescId = zc_Movement_StaffListMember()
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                        AND Movement.Id <> COALESCE (ioId,0)
                        AND COALESCE (MovementLinkObject_PositionLevel.ObjectId,0) = COALESCE (inPositionLevelId,0)
                        AND COALESCE (MovementLinkObject_ReasonOut.ObjectId,0) = COALESCE (inReasonOutId,0)
                        AND COALESCE (MovementLinkObject_StaffListKind.ObjectId,0) = COALESCE (inStaffListKindId,0)
                      );
     IF COALESCE (vbMovementId,0) <> 0 
     THEN
         RAISE EXCEPTION '������.���������� ����������� �������� <%> ��� <%>.', (SELECT Movement.InvNumber||' �� '||Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId)
                                                                              , (SELECT Object.ValueData FROM Object WHERE Object.Id = inMemberId);
     END IF;
   
     --�������� ������������� ����������
     vbPersonalId := (SELECT Object_Personal.Id
                      FROM Object AS Object_Personal
                           INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                 ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                                AND ObjectLink_Personal_Member.ChildObjectId = inMemberId
                           INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                 ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                                AND ObjectLink_Personal_Unit.ChildObjectId = inUnitId                      
                           INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                 ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                                AND ObjectLink_Personal_Position.ChildObjectId = inPositionId
                           LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                                ON ObjectLink_Personal_PositionLevel.ObjectId = Object_Personal.Id
                                               AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
                      WHERE Object_Personal.DescId = zc_Object_Personal()
                        AND Object_Personal.isErased = FALSE
                        AND COALESCE (ObjectLink_Personal_PositionLevel.ChildObjectId,0) = COALESCE (inPositionLevelId,0)
                      ); 
   
       
     /*
     --
     IF COALESCE (vbPersonalId,0) <> 0
     THEN
         RAISE EXCEPTION '������.��������� ��� ����������.';
     END IF;                   
     */
     --�������� StaffListKind
     IF inStaffListKindId = zc_Enum_StaffListKind_In()        --����� �� ������ 
     OR inStaffListKindId = zc_Enum_StaffListKind_Add()       --����� �� ���������������� 
     THEN
         vbDateIn := inOperDate;
     END IF;
     --
     IF inStaffListKindId = zc_Enum_StaffListKind_Out()       --����������
     THEN 
         IF COALESCE (inPersonalId_old,0) = 0
         THEN
             RAISE EXCEPTION '������.��������� �� ������.';
         END IF; 
         
         vbDateIn := (SELECT ObjectDate.ValueData
                      FROM ObjectDate
                      WHERE ObjectDate.ObjectId = inPersonalId_old
                           AND ObjectDate.DescId = zc_ObjectDate_Personal_In()
                      );
         vbDateOut    := inOperDate;                          
         vbPersonalId := inPersonalId_old;                    -- ���� ������ ��������� ���. ����������
         vbIsDateOut  := True;
         
     END IF;
     --
     IF inStaffListKindId = zc_Enum_StaffListKind_Send() --�������
     THEN
         IF COALESCE (inPersonalId_old,0) = 0
         THEN
             RAISE EXCEPTION '������.��������� �� ������.';
         END IF;
         vbDateIn := (SELECT ObjectDate.ValueData
                      FROM ObjectDate
                      WHERE ObjectDate.ObjectId = inPersonalId_old
                           AND ObjectDate.DescId = zc_ObjectDate_Personal_In()
                      );
         vbDateSend   := inOperDate;
         vbIsDateSend := True;   
         vbPersonalId := inPersonalId_old;                    -- ���� ������� ��������� ���. ����������
     END IF;

  /*   RAISE EXCEPTION 'Admin - Test = OK vbPersonalId %  %  vbDateIn %  % vbDateOut %  % vbDateSend %  % ', vbPersonalId,  CHR (13)
                                                                      , vbDateIn,  CHR (13)
                                                                      , vbDateOut,  CHR (13)
                                                                      , vbDateSend,  CHR (13) ;     
  */
     --���������� ��������� ����������
  /*   PERFORM gpInsertUpdate_Object_Personal(ioId                              := COALESCE (vbPersonalId,0)         ::Integer    -- ���� ������� <����������>
                                          , inMemberId                        := inMemberId                        ::Integer    -- ������ �� ���.����
                                          , inPositionId                      := inPositionId                      ::Integer    -- ������ �� ���������
                                          , inPositionLevelId                 := inPositionLevelId                 ::Integer    -- ������ �� ������ ���������
                                          , inUnitId                          := inUnitId                          ::Integer    -- ������ �� �������������
                                          , inPersonalGroupId                 := inPersonalGroupId                 ::Integer    -- ����������� �����������
                                          , inPersonalServiceListId           := inPersonalServiceListId           ::Integer    -- ��������� ����������(�������)
                                          , inPersonalServiceListOfficialId   := inPersonalServiceListOfficialId   ::Integer    -- ��������� ����������(��)
                                          , inPersonalServiceListCardSecondId := inPersonalServiceListCardSecondId ::Integer    -- ��������� ����������(����� �2) 
                                          , inPersonalServiceListId_AvanceF2  := inPersonalServiceListId_AvanceF2  ::Integer    --  ��������� ����������(����� ����� �2)
                                          , inSheetWorkTimeId                 := inSheetWorkTimeId                 ::Integer    -- ����� ������ (������ ������ �.��.)
                                          , inStorageLineId                   := inStorageLineId_1                 ::Integer    -- ������ �� ����� ������������
                                          
                                          , inMember_ReferId                  := inMember_ReferId                  ::Integer    -- ������� �������������
                                          , inMember_MentorId                 := inMember_MentorId                 ::Integer    -- ������� ���������� 	
                                          , inReasonOutId                     := inReasonOutId                     ::Integer    -- ������� ���������� 	
                                          
                                          , inDateIn                          := vbDateIn                          ::TDateTime  -- ���� ��������
                                          , inDateOut                         := vbDateOut                         ::TDateTime  -- ���� ���������� 
                                          , inDateSend                        := vbDateSend                        ::TDateTime  -- ���� ��������
                                          , inIsDateOut                       := vbIsDateOut                       ::Boolean    -- ������
                                          , inIsDateSend                      := vbIsDateSend                      ::Boolean    -- ���������
                                          , inIsMain                          := inIsMain                          ::Boolean    -- �������� ����� ������
                                          , inComment                         := inComment                         ::TVarChar  
                                          , inSession                         := inSession                         ::TVarChar   -- ������ ������������ 
                                          ) ;
    
      */
     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_StaffListMember ( ioId                  := ioId
                                                    , inInvNumber           := inInvNumber
                                                    , inOperDate            := inOperDate
                                                    , inMemberId            := inMemberId 
                                                    , inPositionId          := inPositionId
                                                    , inPositionLevelId     := inPositionLevelId    
                                                    , inUnitId              := inUnitId             
                                                    , inPositionId_old      := inPositionId_old     
                                                    , inPositionLevelId_old := inPositionLevelId_old
                                                    , inUnitId_old          := inUnitId_old         
                                                    , inReasonOutId         := inReasonOutId        
                                                    , inStaffListKindId     := inStaffListKindId    
                                                    , inisOfficial          := inisOfficial         
                                                    , inisMain              := inisMain             
                                                    , inComment             := inComment            
                                                    , inUserId              := vbUserId
                                                     );  
 
   /* ���� ������ �� ����������
     --������� ����������
     vbPersonalId := (SELECT tmp.PersonalId
                      FROM (SELECT Object_Personal.Id AS PersonalId
                                 , ROW_NUMBER() OVER(PARTITION BY Object_Personal.Id, ObjectLink_Personal_Unit.ChildObjectId, ObjectLink_Personal_Position.ChildObjectId, COALESCE (ObjectLink_Personal_PositionLevel.ChildObjectId,0), COALESCE (ObjectBoolean_Main.ValueData, FALSE) ) AS Ord
                            FROM Object AS Object_Personal
                                 INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                       ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                                      AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                                      AND ObjectLink_Personal_Member.ChildObjectId = inMemberId
                                 INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                       ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                      AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                                      AND ObjectLink_Personal_Position.ChildObjectId = inPositionId
                                 INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                       ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                      AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                                      AND ObjectLink_Personal_Unit.ChildObjectId = inUnitId
                                 LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                                      ON ObjectLink_Personal_PositionLevel.ObjectId = Object_Personal.Id
                                                     AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
     
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                         ON ObjectBoolean_Main.ObjectId = Object_Personal.Id
                                                        AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()                            
                            WHERE Object_Personal.DescId = zc_Object_Personal()
                              AND Object_Personal.isErased = FALSE
                              AND ObjectLink_Personal_PositionLevel.ChildObjectId = COALESCE (inPositionLevelId,0)
                            ) AS tmp
                      WHERE tmp.Ord = 1
                      );

     -- ��������� ����� ������������
     PERFORM gpInsertUpdate_Object_PersonalByStorageLine (0::Integer, vbPersonalId::Integer, tmp.StorageLineId::Integer, inSession::TVarChar)
     FROM (
           WITH
             --��� ����������� ����� ������������
             tmpSave AS (SELECT tmp.*
                         FROM gpSelect_Object_PersonalByStorageLine (False, inSession) AS tmp
                         WHERE tmp.PersonalId = vbPersonalId
                         )
           , tmpStorageLine AS (SELECT inStorageLineId_1 AS StorageLineId
                                WHERE COALESCE (inStorageLineId_1,0) <> 0
                              UNION
                                SELECT inStorageLineId_2 AS StorageLineId
                                WHERE COALESCE (inStorageLineId_2,0) <> 0
                              UNION
                                SELECT inStorageLineId_3 AS StorageLineId
                                WHERE COALESCE (inStorageLineId_3,0) <> 0
                              UNION
                                SELECT inStorageLineId_4 AS StorageLineId
                                WHERE COALESCE (inStorageLineId_4,0) <> 0
                              UNION
                                SELECT inStorageLineId_5 AS StorageLineId
                                WHERE COALESCE (inStorageLineId_5,0) <> 0
                                )

         SELECT tmpStorageLine.StorageLineId
         FROM tmpStorageLine
              LEFT JOIN tmpSave ON tmpSave.StorageLineId = tmpStorageLine.StorageLineId
         WHERE COALESCE (tmpStorageLine.StorageLineId,0) <> 0 
           AND tmpSave.PersonalId IS NULL
        ) AS tmp
        ;

        */
 
     -- !!! �������� !!!
   -- IF  vbUserId = 9457 THEN RAISE EXCEPTION 'Admin - Test = OK'; END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.25         *
*/

-- ����
--

/*
�������� ����������

 WITH
     tmp AS (SELECT Object_Personal_View.*
                  , ROW_NUMBER () OVER (ORDER BY Object_Personal_View.DateIn, COALESCE (Object_Personal_View.DateSend,zc_DateStart() ) ) AS Ord
                  , ROW_NUMBER () OVER (Partition by memberId  ORDER BY isMain desc, Object_Personal_View.DateIn, COALESCE (Object_Personal_View.DateSend,zc_DateStart() )) AS Ord_member
                  , CASE WHEN isMain = True THEN zc_Enum_StaffListKind_In() ELSE zc_Enum_StaffListKind_Add() END AS StaffListKindId
             FROM Object_Personal_View
             WHERE COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) = zc_DateEnd()
               and (isMain = True --�������� ����� ������
                  OR
                    (isMain <> True AND COALESCE (Object_Personal_View.DateSend,zc_DateStart()) = zc_DateStart())
                    ) -- �� ����������������
               ORDER BY Object_Personal_View.DateIn
            AND inParam = 1
          UNION
            SELECT Object_Personal_View.*
                  , ROW_NUMBER () OVER (ORDER BY Object_Personal_View.DateIn, COALESCE (Object_Personal_View.DateSend,zc_DateStart() ) ) AS Ord
                  , ROW_NUMBER () OVER (Partition by memberId  ORDER BY isMain desc, Object_Personal_View.DateIn, COALESCE (Object_Personal_View.DateSend,zc_DateStart() )) AS Ord_member
                  , CASE WHEN isMain = True THEN zc_Enum_StaffListKind_In() ELSE zc_Enum_StaffListKind_Add() END AS StaffListKindId
             FROM Object_Personal_View
             WHERE COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) = zc_DateEnd()
               and (isMain = True --�������� ����� ������
                  OR
                    (isMain <> True AND COALESCE (Object_Personal_View.DateSend,zc_DateStart()) = zc_DateStart())
                    ) -- �� ����������������
               --and isMain <> True AND COALESCE (Object_Personal_View.DateSend,zc_DateStart()) <> zc_DateStart() -- �������
               --and COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) <> zc_DateEnd()
               --and memberId = 12613167 --11121446 --8780728 --
               ORDER BY Object_Personal_View.DateIn
            AND inParam = 2
          UNION
            SELECT Object_Personal_View.*
                  , ROW_NUMBER () OVER (ORDER BY Object_Personal_View.DateIn, COALESCE (Object_Personal_View.DateSend,zc_DateStart() ) ) AS Ord
                  , ROW_NUMBER () OVER (Partition by memberId  ORDER BY isMain desc, Object_Personal_View.DateIn, COALESCE (Object_Personal_View.DateSend,zc_DateStart() )) AS Ord_member
                  , CASE WHEN isMain = True THEN zc_Enum_StaffListKind_In() ELSE zc_Enum_StaffListKind_Add() END AS StaffListKindId
             FROM Object_Personal_View
             WHERE COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) = zc_DateEnd()
               and (isMain = True --�������� ����� ������
                  OR
                    (isMain <> True AND COALESCE (Object_Personal_View.DateSend,zc_DateStart()) = zc_DateStart())
                    ) -- �� ����������������
               --and isMain <> True AND COALESCE (Object_Personal_View.DateSend,zc_DateStart()) <> zc_DateStart() -- �������
               --and COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) <> zc_DateEnd()
               --and memberId = 12613167 --11121446 --8780728 --
               ORDER BY Object_Personal_View.DateIn
            AND inParam = 3
            )
     
     -- ��������� <��������>
     SELECT lpInsertUpdate_Movement_StaffListMember ( ioId                  := 0    ::Integer
                                                    , inInvNumber           := NULL ::TVarChar
                                                    , inOperDate            := tmp.DateIn
                                                    , inMemberId            := tmp.MemberId 
                                                    , inPositionId          := tmp.PositionId
                                                    , inPositionLevelId     := tmp.PositionLevelId    
                                                    , inUnitId              := tmp.UnitId             
                                                    , inPositionId_old      := 0    ::Integer 
                                                    , inPositionLevelId_old := 0    ::Integer
                                                    , inUnitId_old          := 0    ::Integer     
                                                    , inReasonOutId         := 0    ::Integer   
                                                    , inStaffListKindId     := tmp.StaffListKindId    
                                                    , inisOfficial          := tmp.isOfficial         
                                                    , inisMain              := tmp.isMain             
                                                    , inComment             := '����.' ::TVarChar           
                                                    , inUserId              := inSession
                                                     )
     FROM tmp  
                                                     
*/