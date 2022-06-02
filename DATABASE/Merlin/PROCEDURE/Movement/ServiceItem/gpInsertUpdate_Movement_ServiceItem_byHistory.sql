-- Function: gpInsertUpdate_Movement_ServiceItem_byHistory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ServiceItem_byHistory(TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ServiceItem_byHistory(
     IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ServiceItem());
     vbUserId:= lpGetUserBySession (inSession);

     PERFORM lpInsertUpdate_Movement_ServiceItem_byHistory (inDateStart := tmp.StartDate
                                                          , inDateEnd   := tmp.EndDate
                                                          , inUnitId    := tmp.UnitId
                                                          , inInfoMoneyId        := tmp.InfoMoneyId 
                                                          , inCommentInfoMoneyId := tmp.CommentInfoMoneyId
                                                          , inAmount  := tmp.Value
                                                          , inPrice   := tmp.Price
                                                          , inArea    := tmp.Area
                                                          , inUserId  := vbUserId
                                                           )
     FROM (WITH tmpServiceItem AS (SELECT distinct ObjectLink_Unit.ObjectId           AS ObjectId
                                    , ObjectLink_Unit.ChildObjectId      AS UnitId
                                    , ObjectLink_InfoMoney.ChildObjectId AS InfoMoneyId
                               FROM ObjectLink AS ObjectLink_Unit
                                    LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                                         ON ObjectLink_InfoMoney.ObjectId = ObjectLink_Unit.ObjectId
                                                        AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_ServiceItem_InfoMoney()
                               WHERE ObjectLink_Unit.DescId             = zc_ObjectLink_ServiceItem_Unit()
                               )
            -- Ищем не по inId а по параметрам
          , ObjectHistory_ServiceItem AS
		  (SELECT * 
		   FROM ObjectHistory
                                          WHERE ObjectHistory.ObjectId in(SELECT DISTINCT tmpServiceItem.ObjectId FROM tmpServiceItem)
                                            AND ObjectHistory.DescId   = zc_ObjectHistory_ServiceItem()
		   and ObjectHistory.StartDate > '01.01.1900'
                                           -- AND inStartDate BETWEEN ObjectHistory.StartDate AND ObjectHistory.EndDate
                                         )
       -- Результат
       SELECT
             tmpServiceItem.UnitId                                                 AS UnitId
           ,tmpServiceItem.InfoMoneyId                                           AS InfoMoneyId
           , CASE WHEN TRIM (Object_CommentInfoMoney.ValueData) = '' THEN 0 ELSE Object_CommentInfoMoney.Id END  :: Integer AS CommentInfoMoneyId

           , ObjectHistoryFloat_ServiceItem_Value.ValueData :: TFloat AS Value
           ,  ObjectHistoryFloat_ServiceItem_Price.ValueData :: TFloat AS Price
           , ObjectHistoryFloat_ServiceItem_Area.ValueData             AS Area    
           , ObjectHistory_ServiceItem.StartDate
           , ObjectHistory_ServiceItem.EndDate

       FROM tmpServiceItem
            INNER JOIN ObjectHistory_ServiceItem ON ObjectHistory_ServiceItem.ObjectId = tmpServiceItem.ObjectId

            LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_CommentInfoMoney
                                        ON ObjectHistoryLink_CommentInfoMoney.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                       AND ObjectHistoryLink_CommentInfoMoney.DescId          = zc_ObjectHistoryLink_ServiceItem_CommentInfoMoney()
            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = ObjectHistoryLink_CommentInfoMoney.ObjectId

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_ServiceItem_Value
                                         ON ObjectHistoryFloat_ServiceItem_Value.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                        AND ObjectHistoryFloat_ServiceItem_Value.DescId          = zc_ObjectHistoryFloat_ServiceItem_Value()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_ServiceItem_Price
                                         ON ObjectHistoryFloat_ServiceItem_Price.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                        AND ObjectHistoryFloat_ServiceItem_Price.DescId          = zc_ObjectHistoryFloat_ServiceItem_Price()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_ServiceItem_Area
                                         ON ObjectHistoryFloat_ServiceItem_Area.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                        AND ObjectHistoryFloat_ServiceItem_Area.DescId          = zc_ObjectHistoryFloat_ServiceItem_Area()
										limit 10 
           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.22         *
 */

-- тест
--