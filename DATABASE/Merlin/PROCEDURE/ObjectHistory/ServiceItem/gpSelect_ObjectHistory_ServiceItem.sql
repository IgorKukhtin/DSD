-- Function: gpSelect_ObjectHistory_ServiceItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_ServiceItem (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_ServiceItem (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_ServiceItem(
    IN inUnitId             Integer   , -- �����
    IN inInfoMoneyId        Integer   , -- ������
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, StartDate TDateTime, EndDate TDateTime
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar , UnitGroupNameFull TVarChar
             , Value TFloat, Price TFloat, Area TFloat
             , isErased Boolean
             )
AS
$BODY$
BEGIN

     -- �������� ������
     RETURN QUERY
       WITH 
       tmpUnit AS (SELECT lfSelect_Object_Unit_byGroup.UnitId AS UnitId
                   FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup
                   WHERE inUnitId <> 0
                  UNION
                   SELECT Object.Id AS UnitId
                   FROM Object
                   WHERE Object.DescId = zc_Object_Unit()
                     AND Object.isErased = False
                     AND inUnitId = 0
                   )

     , tmpServiceItem AS (SELECT ObjectLink_Unit.ObjectId           AS ObjectId
                               , ObjectLink_Unit.ChildObjectId      AS UnitId
                               , ObjectLink_InfoMoney.ChildObjectId AS InfoMoneyId
                          FROM ObjectLink AS ObjectLink_Unit
                               INNER JOIN tmpUnit ON tmpUnit.UnitId = COALESCE (ObjectLink_Unit.ChildObjectId,0)
                               LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                                    ON ObjectLink_InfoMoney.ObjectId = ObjectLink_Unit.ObjectId
                                                   AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_ServiceItem_InfoMoney()
                          WHERE ObjectLink_Unit.DescId = zc_ObjectLink_ServiceItem_Unit()
                            --AND (COALESCE (ObjectLink_Unit.ChildObjectId,0) = inUnitId OR inUnitId = 0)
                            AND (COALESCE (ObjectLink_InfoMoney.ChildObjectId,0) = inInfoMoneyId OR inInfoMoneyId = 0)
                          )

     , ObjectHistory_ServiceItem AS (SELECT *
                                     FROM ObjectHistory
                                     WHERE ObjectHistory.ObjectId IN (SELECT DISTINCT tmpServiceItem.ObjectId FROM tmpServiceItem) -- WHERE ;= inUnitId OR inUnitId = 0)
                                       AND ObjectHistory.DescId = zc_ObjectHistory_ServiceItem()
                                     )

       SELECT
             ObjectHistory_ServiceItem.Id                                   AS Id
           , COALESCE(ObjectHistory_ServiceItem.StartDate, CURRENT_DATE) ::TDateTime AS StartDate
           , COALESCE(ObjectHistory_ServiceItem.EndDate,  zc_DateEnd())     AS EndDate
           , Object_InfoMoney.Id                                            AS InfoMoneyId
           , Object_InfoMoney.ObjectCode                                    AS InfoMoneyCode
           , Object_InfoMoney.ValueData                                     AS InfoMoneyName
           , Object_CommentInfoMoney.Id                                     AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ValueData                              AS CommentInfoMoneyName
           
           , Object_Unit.Id                                                 AS UnitId
           , Object_Unit.ObjectCode                                         AS UnitCode
           , Object_Unit.ValueData                                          AS UnitName 
           , ObjectString_Unit_GroupNameFull.ValueData                      AS UnitGroupNameFull

           , ObjectHistoryFloat_ServiceItem_Value.ValueData                 AS Value
           , ObjectHistoryFloat_ServiceItem_Price.ValueData                 AS Price
           , ObjectHistoryFloat_ServiceItem_Area.ValueData                  AS Area
           , FALSE AS isErased

       FROM ObjectHistory_ServiceItem
            /*FULL JOIN (SELECT zc_DateStart() AS StartDate, inUnitId AS ObjectId 
                       WHERE inUnitId <> 0) AS Empty
                                            ON Empty.ObjectId = ObjectHistory_ServiceItem.ObjectId*/

            LEFT JOIN tmpServiceItem ON tmpServiceItem.ObjectId = ObjectHistory_ServiceItem.ObjectId
            
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpServiceItem.UnitId
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpServiceItem.InfoMoneyId

            LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_ServiceItem_CommentInfoMoney
                                        ON ObjectHistoryLink_ServiceItem_CommentInfoMoney.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                       AND ObjectHistoryLink_ServiceItem_CommentInfoMoney.DescId = zc_ObjectHistoryLink_ServiceItem_CommentInfoMoney()
            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = ObjectHistoryLink_ServiceItem_CommentInfoMoney.ObjectId

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_ServiceItem_Value
                                         ON ObjectHistoryFloat_ServiceItem_Value.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                        AND ObjectHistoryFloat_ServiceItem_Value.DescId = zc_ObjectHistoryFloat_ServiceItem_Value()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_ServiceItem_Price
                                         ON ObjectHistoryFloat_ServiceItem_Price.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                        AND ObjectHistoryFloat_ServiceItem_Price.DescId = zc_ObjectHistoryFloat_ServiceItem_Price()           
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_ServiceItem_Area
                                         ON ObjectHistoryFloat_ServiceItem_Area.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                        AND ObjectHistoryFloat_ServiceItem_Area.DescId = zc_ObjectHistoryFloat_ServiceItem_Area()

            LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                   ON ObjectString_Unit_GroupNameFull.ObjectId = Object_Unit.Id
                                  AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()
;



END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.01.22         *
*/

-- ����
-- SELECT * FROM gpSelect_ObjectHistory_ServiceItem (1, 0, zfCalc_UserAdmin())
