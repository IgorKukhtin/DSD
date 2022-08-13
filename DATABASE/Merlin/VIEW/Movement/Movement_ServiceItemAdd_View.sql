
DROP VIEW IF EXISTS Movement_ServiceItemAdd_View;

CREATE OR REPLACE VIEW Movement_ServiceItemAdd_View AS

       SELECT
             Movement.Id
           , Movement.DescId
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Movement.StatusId
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate
            --
           , MovementItem.Id                      AS MovementItemId
           , MovementItem.isErased
           , Object_Unit.Id                AS UnitId
           , Object_Unit.ObjectCode        AS UnitCode
           , Object_Unit.ValueData         AS UnitName
           , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull
           
           , Object_InfoMoney.Id         AS InfoMoneyId
           , Object_InfoMoney.ObjectCode AS InfoMoneyCode
           , Object_InfoMoney.ValueData  AS InfoMoneyName
 
           , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ObjectCode AS CommentInfoMoneyCode
           , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName

           , MovementItem.Amount 
  
           , COALESCE (MIDate_DateStart.ValueData, zc_DateStart()) AS DateStart
           , COALESCE (MIDate_DateEnd.ValueData, zc_DateEnd())     AS DateEnd
           , COALESCE (MovementString_Comment.ValueData,'') ::TVarChar AS Comment
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId  

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId     = zc_MI_Master() 
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_DateStart
                                       ON MIDate_DateStart.MovementItemId = MovementItem.Id
                                      AND MIDate_DateStart.DescId = zc_MIDate_DateStart()  
            LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                       ON MIDate_DateEnd.MovementItemId = MovementItem.Id
                                      AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd() 

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                             ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = MILinkObject_CommentInfoMoney.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                   ON ObjectString_Unit_GroupNameFull.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()  

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

       WHERE Movement.DescId = zc_Movement_ServiceItemAdd()
       ;

ALTER TABLE Movement_ServiceItemAdd_View
  OWNER TO postgres;

/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 01.08.22         *
 */

-- ÚÂÒÚ
-- SELECT * FROM Movement_ServiceItemAdd_View limit 10
