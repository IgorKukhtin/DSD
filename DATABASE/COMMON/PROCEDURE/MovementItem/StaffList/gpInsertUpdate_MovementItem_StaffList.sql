-- Function: gpInsertUpdate_MovementItem_StaffList()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_StaffList (Integer, Integer, Integer,Integer, Integer, Integer,Integer, Integer,  Integer,  TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_StaffList (Integer, Integer, Integer,Integer, Integer, Integer,TVarChar, TVarChar,  TVarChar,  TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_StaffList (Integer, Integer, Integer,Integer, Integer, Integer,TVarChar, TVarChar,  TVarChar,  TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_StaffList (Integer, Integer, Integer,Integer, Integer, Integer,TVarChar, TVarChar,  TVarChar, TFloat,TFloat, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_StaffList(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inPositionId            Integer   , --
    IN inPositionLevelId       Integer   , --
    IN inPersonalId            Integer   , -- 
    IN inStaffPaidKindId       Integer   , -- 
    IN inStaffHoursDayName     TVarChar   , -- 
    IN inStaffHoursName        TVarChar   , -- 
    IN inStaffHoursLengthName  TVarChar   , -- 
    IN inAmount                TFloat    , --
    IN inAmountReport          TFloat    , --
    IN inStaffCount_1          TFloat    , --
    IN inStaffCount_2          TFloat    , --
    IN inStaffCount_3          TFloat    , --
    IN inStaffCount_4          TFloat    , --
    IN inStaffCount_5          TFloat    , --
    IN inStaffCount_6          TFloat    , --
    IN inStaffCount_7          TFloat    , --
    IN inStaffCount_Invent     TFloat    , --
    IN inStaff_Price           TFloat    , --
    IN inStaff_Summ_MK         TFloat    , --
    IN inStaff_Summ_MK3        TFloat    , --
    IN inStaff_Summ_MK6        TFloat    , --
    IN inStaff_Summ_real       TFloat    , --
    IN inStaff_Summ_add        TFloat    , --
    IN inStaff_Summ_total_real  TFloat    , --
    IN inStaff_Summ_total_add   TFloat    , --
    IN inComment               TVarChar  , -- 
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStaffHoursDayId Integer;
           vbStaffHoursId Integer;
           vbStaffHoursLengthId Integer; 
           vbSumm_real_old TFloat;
           vbSumm_add_old TFloat;
           vbSumm_total_real_old TFloat;
           vbSumm_total_add_old TFloat;
           
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_StaffList());

     --������� ����� ������� �����������, ���� �� �������, ����� ��������� �����
     vbStaffHoursDayId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StaffHoursDay() AND TRIM (Object.ValueData) ILIKE TRIM (inStaffHoursDayName) LIMIT 1);
     IF COALESCE (vbStaffHoursDayId,0) = 0 
     THEN 
         -- �� ����� ��������� 
         vbStaffHoursDayId := gpInsertUpdate_Object_StaffHoursDay (ioId        := 0
                                                                 , inCode      := 0
                                                                 , inName      := TRIM (inStaffHoursDayName) ::TVarChar
                                                                 , inComment   := '' ::TVarChar
                                                                 , inSession   := inSession
                                                                   );
     END IF; 

     -- ������� ����� ������� �����������, ���� �� �������, ����� ��������� �����
     vbStaffHoursId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StaffHours() AND TRIM (Object.ValueData) ILIKE TRIM (inStaffHoursName) LIMIT 1);
     IF COALESCE (vbStaffHoursId,0) = 0 
     THEN 
         -- �� ����� ��������� 
         vbStaffHoursId := gpInsertUpdate_Object_StaffHours (ioId        := 0
                                                           , inCode      := 0
                                                           , inName      := TRIM (inStaffHoursName) ::TVarChar
                                                           , inComment   := '' ::TVarChar
                                                           , inSession:= inSession
                                                             );
     END IF;
     
     -- ������
     IF zfConvert_StringToFloat (inStaffHoursLengthName) = 0
     THEN
         inStaffHoursLengthName:= '0';
     END IF;
     -- ������� ����� ������� �����������, ���� �� �������, ����� ��������� �����
     vbStaffHoursLengthId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StaffHoursLength() AND TRIM (Object.ValueData) ILIKE TRIM (inStaffHoursLengthName) LIMIT 1);
     IF COALESCE (vbStaffHoursLengthId,0) = 0 
     THEN 
         -- �� ����� ��������� 
         vbStaffHoursLengthId := gpInsertUpdate_Object_StaffHoursLength (ioId        := 0
                                                                       , inCode      := 0
                                                                       , inName      := TRIM (inStaffHoursLengthName) ::TVarChar
                                                                       , inComment   := '' ::TVarChar
                                                                       , inSession   := inSession
                                                                         );
     END IF;  

     vbSumm_real_old       := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_Staff_Summ_real())       ::TFloat;
     vbSumm_add_old        := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_Staff_Summ_add())        ::TFloat;
     vbSumm_total_real_old := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_Staff_Summ_total_real()) ::TFloat;
     vbSumm_total_add_old  := (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_Staff_Summ_total_add())  ::TFloat;

 
     --����� ������ ��� "��� 1-�� ��.��" ��� "�������� ����"   
     --1, ���� ������  ³������ ������(��� 1-�� ��.��)
     IF COALESCE(inStaff_Summ_real,0) <> COALESCE(vbSumm_real_old,0)
    AND COALESCE(inStaff_Summ_real,0) <> 0
    AND COALESCE(inStaff_Summ_total_real,0) = COALESCE(vbSumm_total_real_old,0)
     THEN
          -- ���������� ³������ ������(�������� ����)
          inStaff_Summ_total_real := (inStaff_Summ_real * inAmount) ::TFloat;
     END IF; 
     --2. ���� ������  ³������ ������(�������� ����)
     IF COALESCE(inStaff_Summ_total_real,0) <> COALESCE(vbSumm_total_real_old,0)
    AND COALESCE(inStaff_Summ_total_real,0) <> 0
    AND COALESCE(inStaff_Summ_real,0) = COALESCE(vbSumm_real_old,0)
     THEN
          -- ���������� ³������ ������(��� 1-�� ��.��)
          inStaff_Summ_real := CASE WHEN COALESCE (inAmount,0) <> 0 THEN inStaff_Summ_total_real / inAmount ELSE 0 END ::TFloat;
     END IF;

     --3. ���� ������  ���������� ����(��� 1-�� ��.��)
     IF COALESCE(inStaff_Summ_add,0) <> COALESCE(vbSumm_add_old,0)
    AND COALESCE(inStaff_Summ_add,0) <> 0
    AND COALESCE(inStaff_Summ_total_add,0) = COALESCE(vbSumm_total_add_old,0)
     THEN
          -- ���������� ���������� ����(�������� ����)
          inStaff_Summ_total_add := (inStaff_Summ_add * inAmount) ::TFloat;
     END IF; 
     --4. ���� ������ ���������� ����(�������� ����)
     IF COALESCE(inStaff_Summ_total_add,0) <> COALESCE(vbSumm_total_add_old,0)
    AND COALESCE(inStaff_Summ_total_add,0) <> 0
    AND COALESCE(inStaff_Summ_add,0) = COALESCE(vbSumm_add_old,0)
     THEN
          -- ���������� ���������� ����(��� 1-�� ��.��)
          inStaff_Summ_add := CASE WHEN COALESCE (inAmount,0) <> 0 THEN inStaff_Summ_total_add / inAmount ELSE 0 END ::TFloat;
     END IF;

                            
     -- ���������
     ioId := lpInsertUpdate_MovementItem_StaffList (ioId                  := ioId
                                                  , inMovementId          := inMovementId
                                                  , inPositionId          := inPositionId
                                                  , inPositionLevelId     := inPositionLevelId
                                                  , inPersonalId          := inPersonalId    
                                                  , inStaffPaidKindId     := inStaffPaidKindId    
                                                  , inStaffHoursDayId     := vbStaffHoursDayId    
                                                  , inStaffHoursId        := vbStaffHoursId       
                                                  , inStaffHoursLengthId  := vbStaffHoursLengthId
                                                  , inAmount              := inAmount             
                                                  , inAmountReport        := inAmountReport       
                                                  , inStaffCount_1        := inStaffCount_1       
                                                  , inStaffCount_2        := inStaffCount_2       
                                                  , inStaffCount_3        := inStaffCount_3       
                                                  , inStaffCount_4        := inStaffCount_4       
                                                  , inStaffCount_5        := inStaffCount_5
                                                  , inStaffCount_6        := inStaffCount_6       
                                                  , inStaffCount_7        := inStaffCount_7       
                                                  , inStaffCount_Invent   := inStaffCount_Invent  
                                                  , inStaff_Price         := inStaff_Price        
                                                  , inStaff_Summ_MK       := inStaff_Summ_MK
                                                  , inStaff_Summ_MK3      := inStaff_Summ_MK3
                                                  , inStaff_Summ_MK6      := inStaff_Summ_MK6
                                                  , inStaff_Summ_real     := inStaff_Summ_real    
                                                  , inStaff_Summ_add      := inStaff_Summ_add
                                                  , inStaff_Summ_total_real := inStaff_Summ_total_real    
                                                  , inStaff_Summ_total_add  := inStaff_Summ_total_add
                                                  , inComment             := inComment
                                                  , inUserId              := vbUserId
                                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.10.25         * Staff_Summ_MK3, Staff_Summ_MK6
 20.08.25         *
*/

-- ����
--