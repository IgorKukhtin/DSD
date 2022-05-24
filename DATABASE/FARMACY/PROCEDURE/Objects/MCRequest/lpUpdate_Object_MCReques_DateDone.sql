-- Function: lpUpdate_Object_MCReques_DateDone(Integer)

DROP FUNCTION IF EXISTS lpUpdate_Object_MCReques_DateDone (Integer);


CREATE OR REPLACE FUNCTION lpUpdate_Object_MCReques_DateDone(
  IN inUserId                Integer     -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbIsResult Boolean;
BEGIN

   vbIsResult := False;
 
   IF EXISTS (SELECT 1
              FROM Object AS Object_MCReques

                   LEFT JOIN ObjectDate AS ObjectDate_DateUpdate
                                        ON ObjectDate_DateUpdate.ObjectId = Object_MCReques.Id
                                       AND ObjectDate_DateUpdate.DescId = zc_ObjectDate_MCRequest_DateUpdate()
                   LEFT JOIN ObjectDate AS ObjectDate_DateDone
                                        ON ObjectDate_DateDone.ObjectId = Object_MCReques.Id
                                       AND ObjectDate_DateDone.DescId = zc_ObjectDate_MCRequest_DateDone()

              WHERE Object_MCReques.DescId = zc_Object_MCRequest()
                AND Object_MCReques.ObjectCode = 1
                AND ObjectDate_DateDone.ValueData IS NULL)
   THEN   
       IF NOT EXISTS (WITH 
                          tmpMarginCategoryItem AS (SELECT DISTINCT
                                                           Object_MarginCategoryItem_View.MarginPercent,
                                                           Object_MarginCategoryItem_View.MinPrice,
                                                           Object_MarginCategoryItem_View.MarginCategoryId
                                                    FROM Object_MarginCategoryItem_View
                                                         INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                                                                       AND Object_MarginCategoryItem.isErased = FALSE
                                                    WHERE Object_MarginCategoryItem_View.MarginCategoryId = 4194130 
                                                    ),
                          tmpMCRequesItem AS (SELECT ObjectFloat_MinPrice.ValueData              AS MinPrice
                                                   , ObjectFloat_MarginPercentOld.ValueData      AS MarginPercentOld
                                                   , ObjectFloat_MarginPercent.ValueData         AS MarginPercent
                                                   , ObjectDate_DateUpdate.ValueData             AS DataUpdate
                                                   , ObjectDate_DateDone.ValueData               AS DateDone
                                              FROM Object AS Object_MCReques

                                                   LEFT JOIN ObjectDate AS ObjectDate_DateUpdate
                                                                        ON ObjectDate_DateUpdate.ObjectId = Object_MCReques.Id
                                                                       AND ObjectDate_DateUpdate.DescId = zc_ObjectDate_MCRequest_DateUpdate()
                                                   LEFT JOIN ObjectDate AS ObjectDate_DateDone
                                                                        ON ObjectDate_DateDone.ObjectId = Object_MCReques.Id
                                                                       AND ObjectDate_DateDone.DescId = zc_ObjectDate_MCRequest_DateDone()
                                                         
                                                   LEFT JOIN ObjectLink AS ObjectLink_MCRequest
                                                                        ON ObjectLink_MCRequest.ChildObjectId = Object_MCReques.Id
                                                                       AND ObjectLink_MCRequest.DescId = zc_ObjectLink_MCRequestItem_MCRequest()
                                                                                                       
                                                   LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                                                         ON ObjectFloat_MinPrice.ObjectId = ObjectLink_MCRequest.ObjectId
                                                                        AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MCRequestItem_MinPrice()
                                                   LEFT JOIN ObjectFloat AS ObjectFloat_MarginPercent
                                                                         ON ObjectFloat_MarginPercent.ObjectId = ObjectLink_MCRequest.ObjectId
                                                                        AND ObjectFloat_MarginPercent.DescId = zc_ObjectFloat_MCRequestItem_MarginPercent()
                                                   LEFT JOIN ObjectFloat AS ObjectFloat_MarginPercentOld
                                                                         ON ObjectFloat_MarginPercentOld.ObjectId = ObjectLink_MCRequest.ObjectId
                                                                        AND ObjectFloat_MarginPercentOld.DescId = zc_ObjectFloat_MCRequestItem_MarginPercentOld()

                                              WHERE Object_MCReques.DescId = zc_Object_MCRequest()
                                                AND Object_MCReques.ObjectCode = 1
                                                AND ObjectDate_DateDone.ValueData IS NULL
                                              )
                                                 
                     SELECT tmpMarginCategoryItem.MinPrice         AS MinPrice 
                          , tmpMarginCategoryItem.MarginPercent    AS MarginPercentCurr
                          , tmpMCRequesItem.MarginPercent          AS MarginPercent
                          , tmpMCRequesItem.DateDone
                     FROM tmpMarginCategoryItem
                     
                          INNER JOIN tmpMCRequesItem ON tmpMCRequesItem.MinPrice = tmpMarginCategoryItem.MinPrice
                          
                     WHERE (tmpMarginCategoryItem.MarginPercent <> COALESCE(tmpMCRequesItem.MarginPercent, 0)))
       THEN   
       
         -- Сохранили Дату сравнения
         -- сохранили протокол
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_MCRequest_DateDone(), Object_MCReques.Id, CURRENT_TIMESTAMP)
               , lpInsert_ObjectProtocol (Object_MCReques.Id, inUserId)
         FROM Object AS Object_MCReques
         WHERE Object_MCReques.DescId = zc_Object_MCRequest()
           AND Object_MCReques.ObjectCode = 1;
         
         vbIsResult := True;
       END IF;
   ELSE 
     vbIsResult := True;
   END IF;

   RETURN vbIsResult;


END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.05.22                                                       *
*/

-- тест
-- SELECT * FROM lpUpdate_Object_MCReques_DateDone(3);