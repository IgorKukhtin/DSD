-- Function: gpInsert_MI_StaffList_byMovement()

DROP FUNCTION IF EXISTS gpInsert_MI_StaffList_byMovement (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_StaffList_byMovement(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementId_mask     Integer   , -- Ключ объекта <Документ  >
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_StaffList());

     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_StaffList (ioId                  := tmp.MovementItemId
                                                  , inMovementId          := inMovementId
                                                  , inPositionId          := tmp.PositionId
                                                  , inPositionLevelId     := tmp.PositionLevelId    
                                                  , inStaffPaidKindId     := tmp.StaffPaidKindId    
                                                  , inStaffHoursDayId     := tmp.StaffHoursDayId    
                                                  , inStaffHoursId        := tmp.StaffHoursId       
                                                  , inStaffHoursLengthId  := tmp.StaffHoursLengthId
                                                  , inPersonalId          := tmp.PersonalId         
                                                  , inAmount              := tmp.Amount             
                                                  , inAmountReport        := tmp.AmountReport       
                                                  , inStaffCount_1        := tmp.StaffCount_1       
                                                  , inStaffCount_2        := tmp.StaffCount_2       
                                                  , inStaffCount_3        := tmp.StaffCount_3       
                                                  , inStaffCount_4        := tmp.StaffCount_4       
                                                  , inStaffCount_5        := tmp.StaffCount_5
                                                  , inStaffCount_6        := tmp.StaffCount_6       
                                                  , inStaffCount_7        := tmp.StaffCount_7       
                                                  , inStaffCount_Invent   := tmp.StaffCount_Invent  
                                                  , inStaff_Price         := tmp.Staff_Price        
                                                  , inStaff_Summ_MK       := tmp.Staff_Summ_MK
                                                  , inStaff_Summ_MK3      := tmp.Staff_Summ_MK3
                                                  , inStaff_Summ_MK6      := tmp.Staff_Summ_MK6
                                                  , inStaff_Summ_real     := tmp.Staff_Summ_real    
                                                  , inStaff_Summ_add      := tmp.Staff_Summ_add
                                                  , inComment             := tmp.Comment
                                                  , inUserId              := vbUserId
                                                  
                                             )
       FROM (SELECT COALESCE (tmpMI.MovementItemId,0) AS MovementItemId
                  , tmpMI_mask.ObjectId AS PositionId
                  , tmpMI_mask.PositionLevelId
                  , tmpMI_mask.StaffPaidKindId
                  , tmpMI_mask.StaffHoursDayId
                  , tmpMI_mask.StaffHoursId
                  , tmpMI_mask.StaffHoursLengthId
                  , tmpMI_mask.PersonalId
                  , tmpMI_mask.Amount            ::TFloat
                  , tmpMI_mask.AmountReport      ::TFloat
                  , tmpMI_mask.StaffCount_1      ::TFloat
                  , tmpMI_mask.StaffCount_2      ::TFloat
                  , tmpMI_mask.StaffCount_3      ::TFloat
                  , tmpMI_mask.StaffCount_4      ::TFloat
                  , tmpMI_mask.StaffCount_5      ::TFloat
                  , tmpMI_mask.StaffCount_6      ::TFloat
                  , tmpMI_mask.StaffCount_7      ::TFloat
                  , tmpMI_mask.StaffCount_Invent ::TFloat
                  , tmpMI_mask.Staff_Price       ::TFloat
                  , tmpMI_mask.Staff_Summ_MK     ::TFloat 
                  , tmpMI_mask.Staff_Summ_MK3    ::TFloat
                  , tmpMI_mask.Staff_Summ_MK6    ::TFloat
                  , tmpMI_mask.Staff_Summ_real   ::TFloat
                  , tmpMI_mask.Staff_Summ_add    ::TFloat
                  , tmpMI_mask.Comment           ::TVarChar
            FROM (WITH 
                  tmpMI AS (SELECT MovementItem.*
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId_mask
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
                           )

                , tmpMIFloat AS (SELECT MovementItemFloat.*
                                  FROM MovementItemFloat
                                  WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                                 )
      
                , tmpMILinkObject AS (SELECT MovementItemLinkObject.*
                                      FROM MovementItemLinkObject
                                      WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                                     )
      
                , tmpMIString AS (SELECT MovementItemString.*
                                  FROM MovementItemString
                                  WHERE MovementItemString.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                                    AND MovementItemString.DescId = zc_MIString_Comment()
                                 )
                  SELECT MovementItem.*
                       , MILinkObject_PositionLevel.ObjectId                        AS PositionLevelId
                       , MILinkObject_StaffPaidKind.ObjectId                        AS StaffPaidKindId
                       , MILinkObject_StaffHoursDay.ObjectId                        AS StaffHoursDayId
                       , MILinkObject_StaffHours.ObjectId                           AS StaffHoursId
                       , MILinkObject_StaffHoursLength.ObjectId                     AS StaffHoursLengthId
                       , MILinkObject_Personal.ObjectId                             AS PersonalId
                       , COALESCE (MIFloat_AmountReport.ValueData, 0)      ::TFloat AS AmountReport
                       , COALESCE (MIFloat_StaffCount_1.ValueData, 0)      ::TFloat AS StaffCount_1
                       , COALESCE (MIFloat_StaffCount_2.ValueData, 0)      ::TFloat AS StaffCount_2
                       , COALESCE (MIFloat_StaffCount_3.ValueData, 0)      ::TFloat AS StaffCount_3
                       , COALESCE (MIFloat_StaffCount_4.ValueData, 0)      ::TFloat AS StaffCount_4
                       , COALESCE (MIFloat_StaffCount_5.ValueData, 0)      ::TFloat AS StaffCount_5
                       , COALESCE (MIFloat_StaffCount_6.ValueData, 0)      ::TFloat AS StaffCount_6
                       , COALESCE (MIFloat_StaffCount_7.ValueData, 0)      ::TFloat AS StaffCount_7
                       , COALESCE (MIFloat_StaffCount_Invent.ValueData, 0) ::TFloat AS StaffCount_Invent
                       , COALESCE (MIFloat_Staff_Price.ValueData, 0)       ::TFloat AS Staff_Price
                       , COALESCE (MIFloat_Staff_Summ_MK.ValueData, 0)     ::TFloat AS Staff_Summ_MK
                       , COALESCE (MIFloat_Staff_Summ_MK3.ValueData, 0)    ::TFloat AS Staff_Summ_MK3
                       , COALESCE (MIFloat_Staff_Summ_MK6.ValueData, 0)    ::TFloat AS Staff_Summ_MK6
                       , COALESCE (MIFloat_Staff_Summ_real.ValueData, 0)   ::TFloat AS Staff_Summ_real
                       , COALESCE (MIFloat_Staff_Summ_add.ValueData, 0)    ::TFloat AS Staff_Summ_add
                       , MIString_Comment.ValueData                        ::TVarChar AS Comment

                  FROM tmpMI AS MovementItem
                       LEFT JOIN tmpMIFloat AS MIFloat_AmountReport
                                            ON MIFloat_AmountReport.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountReport.DescId = zc_MIFloat_AmountReport()
                       LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_1
                                            ON MIFloat_StaffCount_1.MovementItemId = MovementItem.Id
                                           AND MIFloat_StaffCount_1.DescId = zc_MIFloat_StaffCount_1()
                       LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_2
                                            ON MIFloat_StaffCount_2.MovementItemId = MovementItem.Id
                                           AND MIFloat_StaffCount_2.DescId = zc_MIFloat_StaffCount_2()
                       LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_3
                                            ON MIFloat_StaffCount_3.MovementItemId = MovementItem.Id
                                           AND MIFloat_StaffCount_3.DescId = zc_MIFloat_StaffCount_3()
                       LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_4
                                            ON MIFloat_StaffCount_4.MovementItemId = MovementItem.Id
                                           AND MIFloat_StaffCount_4.DescId = zc_MIFloat_StaffCount_4()
                       LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_5
                                            ON MIFloat_StaffCount_5.MovementItemId = MovementItem.Id
                                           AND MIFloat_StaffCount_5.DescId = zc_MIFloat_StaffCount_5()
                       LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_6
                                            ON MIFloat_StaffCount_6.MovementItemId = MovementItem.Id
                                           AND MIFloat_StaffCount_6.DescId = zc_MIFloat_StaffCount_6()
                       LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_7
                                            ON MIFloat_StaffCount_7.MovementItemId = MovementItem.Id
                                           AND MIFloat_StaffCount_7.DescId = zc_MIFloat_StaffCount_7()
                       LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_Invent
                                            ON MIFloat_StaffCount_Invent.MovementItemId = MovementItem.Id
                                           AND MIFloat_StaffCount_Invent.DescId = zc_MIFloat_StaffCount_Invent()
                       LEFT JOIN tmpMIFloat AS MIFloat_Staff_Price
                                            ON MIFloat_Staff_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Staff_Price.DescId = zc_MIFloat_Staff_Price()
                       LEFT JOIN tmpMIFloat AS MIFloat_Staff_Summ_MK
                                            ON MIFloat_Staff_Summ_MK.MovementItemId = MovementItem.Id
                                           AND MIFloat_Staff_Summ_MK.DescId = zc_MIFloat_Staff_Summ_MK()

                       LEFT JOIN tmpMIFloat AS MIFloat_Staff_Summ_MK3
                                            ON MIFloat_Staff_Summ_MK3.MovementItemId = MovementItem.Id
                                           AND MIFloat_Staff_Summ_MK3.DescId = zc_MIFloat_Staff_Summ_MK_3()
                       LEFT JOIN tmpMIFloat AS MIFloat_Staff_Summ_MK6
                                            ON MIFloat_Staff_Summ_MK6.MovementItemId = MovementItem.Id
                                           AND MIFloat_Staff_Summ_MK6.DescId = zc_MIFloat_Staff_Summ_MK_6()

                       LEFT JOIN tmpMIFloat AS MIFloat_Staff_Summ_real
                                            ON MIFloat_Staff_Summ_real.MovementItemId = MovementItem.Id
                                           AND MIFloat_Staff_Summ_real.DescId = zc_MIFloat_Staff_Summ_real()
                       LEFT JOIN tmpMIFloat AS MIFloat_Staff_Summ_add
                                            ON MIFloat_Staff_Summ_add.MovementItemId = MovementItem.Id
                                           AND MIFloat_Staff_Summ_add.DescId = zc_MIFloat_Staff_Summ_add()

                       LEFT JOIN tmpMILinkObject AS MILinkObject_PositionLevel
                                                 ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                       LEFT JOIN tmpMILinkObject AS MILinkObject_StaffPaidKind
                                                 ON MILinkObject_StaffPaidKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_StaffPaidKind.DescId = zc_MILinkObject_StaffPaidKind()
                       LEFT JOIN tmpMILinkObject AS MILinkObject_StaffHoursDay
                                                 ON MILinkObject_StaffHoursDay.MovementItemId = MovementItem.Id
                                                AND MILinkObject_StaffHoursDay.DescId = zc_MILinkObject_StaffHoursDay()
                       LEFT JOIN tmpMILinkObject AS MILinkObject_StaffHours
                                                 ON MILinkObject_StaffHours.MovementItemId = MovementItem.Id
                                                AND MILinkObject_StaffHours.DescId = zc_MILinkObject_StaffHours()
                       LEFT JOIN tmpMILinkObject AS MILinkObject_StaffHoursLength
                                                 ON MILinkObject_StaffHoursLength.MovementItemId = MovementItem.Id
                                                AND MILinkObject_StaffHoursLength.DescId = zc_MILinkObject_StaffHoursLength()
                       LEFT JOIN tmpMILinkObject AS MILinkObject_Personal
                                                 ON MILinkObject_Personal.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Personal.DescId = zc_MILinkObject_Personal()
                       LEFT JOIN tmpMIString AS MIString_Comment
                                             ON MIString_Comment.MovementItemId = MovementItem.Id
                                            AND MIString_Comment.DescId = zc_MIString_Comment()
                  ) tmpMI_mask

                  LEFT JOIN (SELECT MovementItem.Id                               AS MovementItemId
                                  , MovementItem.ObjectId                         AS PositionId
                                  , COALESCE (MILinkObject_PositionLevel.ObjectId, 0) AS PositionLevelId
                             FROM MovementItem 
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                                                   ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE
                                 
                            ) AS tmpMI ON tmpMI.PositionId = tmpMI_mask.ObjectId
                                      AND COALESCE (tmpMI.PositionLevelId,0) = COALESCE (tmpMI_mask.PositionLevelId,0)
           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.25         * Staff_Summ_MK3, Staff_Summ_MK6
 26.08.25         *
*/

-- тест
--