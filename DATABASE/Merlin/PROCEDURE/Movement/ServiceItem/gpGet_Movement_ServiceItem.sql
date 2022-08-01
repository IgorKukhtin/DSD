-- Function: gpGet_Movement_ServiceItem()

DROP FUNCTION IF EXISTS gpGet_Movement_ServiceItem (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ServiceItem(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementId_Value  Integer   ,    
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime 
             , MovementItemId Integer
             , UnitId Integer, UnitName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyName TVarChar
             , Amount TFloat, Price TFloat, Area TFloat
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_serviceitem_seq') AS TVarChar)  AS InvNumber
           , CURRENT_DATE                          :: TDateTime       AS OperDate
           
           , 0            AS MovementItemId 
           , 0            AS UnitId
           , ''::TVarChar AS UnitName
           , 0            AS InfoMoneyId
           , ''::TVarChar AS InfoMoneyName
           , 0            AS CommentInfoMoneyId
           , ''::TVarChar AS CommentInfoMoneyName
 
           , 0               :: TFloat    AS Amount
           , 0               :: TFloat    AS Price
           , 0               :: TFloat    AS Area 
       FROM Object AS Object_Insert
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = zc_Enum_Status_UnComplete()
       WHERE Object_Insert.Id = vbUserId
      ;
     ELSE
     
     RETURN QUERY 
       SELECT
             inMovementId AS Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('movement_serviceitem_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN CAST (CURRENT_DATE AS TDateTime) ELSE Movement.OperDate END ::TDateTime AS OperDate   

           , MovementItem.Id                      AS MovementItemId
           , Object_Unit.Id                       AS UnitId
           , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName
           
           , Object_InfoMoney.Id                   AS InfoMoneyId
           , Object_InfoMoney.ValueData ::TVarChar AS InfoMoneyName

           , Object_CommentInfoMoney.Id            AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ValueData ::TVarChar AS CommentInfoMoneyName

           , MovementItem.Amount                  ::TFloat AS Amount
           , COALESCE (MIFloat_Price.ValueData, 0)::TFloat AS Price
           , COALESCE (MIFloat_Area.ValueData, 0) ::TFloat AS Area

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

           --строки
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.isErased = FALSE            
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price() 

            LEFT JOIN MovementItemFloat AS MIFloat_Area
                                        ON MIFloat_Area.MovementItemId = MovementItem.Id
                                       AND MIFloat_Area.DescId = zc_MIFloat_Area()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                             ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_CommentInfoMoney.DescId = zc_MILinkObject_CommentInfoMoney()  
            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = MILinkObject_CommentInfoMoney.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                   ON ObjectString_Unit_GroupNameFull.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull() 

       WHERE Movement.Id = inMovementId_Value;

   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.08.22         * add MI
 31.05.22         *
 */

-- тест
-- select * from gpGet_Movement_ServiceItem(inMovementId := 0 , inMovementId_Value := 0 , inOperDate := ('01.06.2022')::TDateTime ,  inSession := '5');
