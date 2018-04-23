-- Function:  gpSelect_Object_ClientBySMS()

DROP FUNCTION IF EXISTS gpSelect_Object_ClientBySMS (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ClientBySMS (
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inIsShowAll        Boolean  ,  -- признак показать все да / нет
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DiscountCard TVarChar, DiscountTax TFloat, DiscountTaxTwo TFloat
             , AmountDebt TFloat, SummDebt TFloat
             , LastCount TFloat, LastSumm TFloat, LastSummDiscount TFloat
             , LastDate TDateTime
             , Address TVarChar, HappyDate TDateTime, PhoneMobile TVarChar, Phone TVarChar
             , Mail TVarChar, Comment TVarChar, CityName TVarChar
             , DiscountKindName TVarChar
             , LastUserName TVarChar, UnitName_User TVarChar
             , UnitName_insert TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isMotion boolean
             , isErased boolean
  )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH
    tmpContainer AS (SELECT tmp.UnitId
                          , tmp.ClientId

                          , SUM (tmp.EndAmount) AS EndAmount
                          , SUM (tmp.EndSum) AS EndSum
                          , SUM (tmp.Amount_Period) AS Amount_Period
                          , SUM (tmp.Summ_Period) AS Summ_Period
                     FROM (SELECT CLO_Unit.ObjectId                AS UnitId
                                , CLO_Client.ObjectId              AS ClientId
      
                                , (CASE WHEN Container.DescId = zc_Container_count() 
                                            THEN Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END) AS EndAmount
                                , (CASE WHEN Container.DescId = zc_Container_Summ() 
                                            THEN Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END) AS EndSum
      
                               -- Кол-во за ПЕРИОД
                              , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.DescId = zc_MIContainer_Count()
                                           THEN COALESCE (MIContainer.Amount, 0)
                                          ELSE 0
                                     END) AS Amount_Period
                                -- сумма за ПЕРИОД
                              , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.DescId = zc_MIContainer_Summ()
                                           THEN COALESCE (MIContainer.Amount, 0)
                                          ELSE 0
                                     END) AS Summ_Period
                                
                           FROM Container
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ContainerId = Container.Id
                                                              AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                              AND (CLO_Unit.ObjectId    = inUnitId OR inUnitId = 0)
                                LEFT JOIN ContainerLinkObject AS CLO_Client
                                                              ON CLO_Client.ContainerId = Container.Id
                                                             AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                LEFT JOIN ContainerLinkObject AS CLO_PartionMI
                                                              ON CLO_PartionMI.ContainerId = Container.Id
                                                             AND CLO_PartionMI.DescId = zc_ContainerLinkObject_PartionMI()
                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.Containerid = Container.Id
                                                               AND MIContainer.OperDate >= inStartDate
                           WHERE Container.ObjectId <> zc_Enum_Account_20102()
                           GROUP BY CLO_Unit.ObjectId
                                  , CLO_Client.ObjectId
                                  , Container.PartionId
                                  , CLO_PartionMI.ObjectId
                                  , Container.Amount 
                                  , Container.DescId
                           HAVING  (CASE WHEN Container.DescId = zc_Container_count() 
                                            THEN Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END) <> 0
                               OR  (CASE WHEN Container.DescId = zc_Container_Summ() 
                                            THEN Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END) <> 0
                                            
                               OR SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.DescId = zc_MIContainer_Count() THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) <> 0
                               OR SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.DescId = zc_MIContainer_Summ() THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) <> 0
                           ) AS tmp
                     GROUP BY tmp.UnitId
                            , tmp.ClientId
                     )

  , tmpClient AS (SELECT Object_Client.*
                  FROM Object AS Object_Client
                       LEFT JOIN ObjectLink AS ObjectLink_Client_InsertUnit
                                            ON ObjectLink_Client_InsertUnit.ObjectId = Object_Client.Id
                                           AND ObjectLink_Client_InsertUnit.DescId   = zc_ObjectLink_Client_InsertUnit()
                                 
                       LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                                            ON ObjectDate_Protocol_Insert.ObjectId = Object_Client.Id
                                           AND ObjectDate_Protocol_Insert.DescId   = zc_ObjectDate_Protocol_Insert()
                       -- долг, движение
                       LEFT JOIN tmpContainer ON tmpContainer.ClientId = Object_Client.Id

                  WHERE Object_Client.DescId = zc_Object_Client()
                    AND (COALESCE (tmpContainer.EndAmount, 0) <> 0 
                                                 OR COALESCE (tmpContainer.EndSum, 0) <> 0
                                                 OR COALESCE (tmpContainer.Summ_Period, 0) <> 0 
                                                 OR COALESCE (tmpContainer.Amount_Period, 0) <> 0
                                                 OR (ObjectLink_Client_InsertUnit.ChildObjectId = inUnitId 
                                                   AND ObjectDate_Protocol_Insert.ValueData >= inStartDate AND ObjectDate_Protocol_Insert.ValueData < inEndDate + interval '1 day')
                                                   )
                  )

       --результат
       SELECT
             Object_Client.Id                        AS Id
           , Object_Client.ObjectCode                AS Code
           , Object_Client.ValueData                 AS Name
           , ObjectString_DiscountCard.ValueData     AS DiscountCard
           
           , ObjectFloat_DiscountTax.ValueData       AS DiscountTax
           , ObjectFloat_DiscountTaxTwo.ValueData    AS DiscountTaxTwo
           
           , COALESCE (tmpContainer.EndAmount, 0) :: TFloat AS AmountDebt
           , COALESCE (tmpContainer.EndSum, 0)    :: TFloat AS SummDebt
           , ObjectFloat_LastCount.ValueData         AS LastCount
           , ObjectFloat_LastSumm.ValueData          AS LastSumm
           , ObjectFloat_LastSummDiscount.ValueData  AS LastSummDiscount
           
           , ObjectDate_LastDate.ValueData           AS LastDate
           , ObjectString_Address.ValueData          AS Address
           , ObjectDate_HappyDate.ValueData          AS HappyDate
           , ObjectString_PhoneMobile.ValueData      AS PhoneMobile
           , ObjectString_Phone.ValueData            AS Phone
           , ObjectString_Mail.ValueData             AS Mail
           , ObjectString_Comment.ValueData          AS Comment
           , Object_City.ValueData                   AS CityName
           , Object_DiscountKind.ValueData           AS DiscountKindName
           , Object_LastUser.ValueData               AS LastUserName
           , Object_Unit.ValueData                   AS UnitName_User

           , Object_Unit_Insert.ValueData            AS UnitName_insert
           , Object_User_Insert.ValueData            AS InsertName
           , ObjectDate_Protocol_Insert.ValueData    AS InsertDate
           
           , CASE WHEN COALESCE (tmpContainer.Amount_Period, 0) <> 0  OR COALESCE (tmpContainer.Summ_Period, 0) <> 0 THEN TRUE ELSE FALSE END AS isMotion

           , CASE WHEN Object_Client.isErased = TRUE OR (tmpClient.Id Is Null) THEN TRUE ELSE FALSE END   AS isErased

       FROM (SELECT Object_Client.*
             FROM Object AS Object_Client
             WHERE Object_Client.DescId = zc_Object_Client() AND inIsShowAll = TRUE
           UNION 
             SELECT tmpClient.*
             FROM tmpClient
             WHERE inIsShowAll = FALSE
             ) AS Object_Client
            LEFT JOIN tmpClient ON tmpClient.Id = Object_Client.Id
            LEFT JOIN ObjectLink AS ObjectLink_Client_City
                                 ON ObjectLink_Client_City.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_City.DescId = zc_ObjectLink_Client_City()
            LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Client_City.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Client_DiscountKind
                                 ON ObjectLink_Client_DiscountKind.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_DiscountKind.DescId = zc_ObjectLink_Client_DiscountKind()
            LEFT JOIN Object AS Object_DiscountKind ON Object_DiscountKind.Id = ObjectLink_Client_DiscountKind.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_DiscountCard
                                   ON ObjectString_DiscountCard.ObjectId = Object_Client.Id
                                  AND ObjectString_DiscountCard.DescId = zc_ObjectString_Client_DiscountCard()

            LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                  ON ObjectFloat_DiscountTax.ObjectId = Object_Client.Id
                                 AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Client_DiscountTax()

            LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTaxTwo
                                  ON ObjectFloat_DiscountTaxTwo.ObjectId = Object_Client.Id
                                 AND ObjectFloat_DiscountTaxTwo.DescId = zc_ObjectFloat_Client_DiscountTaxTwo()
            LEFT JOIN ObjectFloat AS ObjectFloat_LastCount
                                  ON ObjectFloat_LastCount.ObjectId = Object_Client.Id
                                 AND ObjectFloat_LastCount.DescId = zc_ObjectFloat_Client_LastCount()

            LEFT JOIN ObjectFloat AS ObjectFloat_LastSumm
                                  ON ObjectFloat_LastSumm.ObjectId = Object_Client.Id
                                 AND ObjectFloat_LastSumm.DescId = zc_ObjectFloat_Client_LastSumm()

            LEFT JOIN ObjectFloat AS ObjectFloat_LastSummDiscount
                                  ON ObjectFloat_LastSummDiscount.ObjectId = Object_Client.Id
                                 AND ObjectFloat_LastSummDiscount.DescId = zc_ObjectFloat_Client_LastSummDiscount()

            LEFT JOIN ObjectDate AS  ObjectDate_LastDate
                                  ON ObjectDate_LastDate.ObjectId = Object_Client.Id
                                 AND ObjectDate_LastDate.DescId = zc_ObjectDate_Client_LastDate()

            LEFT JOIN ObjectString AS ObjectString_Address
                                   ON ObjectString_Address.ObjectId = Object_Client.Id
                                  AND ObjectString_Address.DescId = zc_ObjectString_Client_Address()

            LEFT JOIN ObjectDate AS ObjectDate_HappyDate
                                 ON ObjectDate_HappyDate.ObjectId = Object_Client.Id
                                AND ObjectDate_HappyDate.DescId = zc_ObjectDate_Client_HappyDate()

            LEFT JOIN ObjectString AS ObjectString_PhoneMobile
                                   ON ObjectString_PhoneMobile.ObjectId = Object_Client.Id
                                  AND ObjectString_PhoneMobile.DescId = zc_ObjectString_Client_PhoneMobile()

            LEFT JOIN ObjectString AS ObjectString_Phone
                                   ON ObjectString_Phone.ObjectId = Object_Client.Id
                                  AND ObjectString_Phone.DescId = zc_ObjectString_Client_Phone()

            LEFT JOIN ObjectString AS ObjectString_Mail
                                   ON ObjectString_Mail.ObjectId = Object_Client.Id
                                  AND ObjectString_Mail.DescId = zc_ObjectString_Client_Mail()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Client.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Client_Comment()
            LEFT JOIN ObjectLink AS ObjectLink_Client_LastUser
                                 ON ObjectLink_Client_LastUser.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_LastUser.DescId = zc_ObjectLink_Client_LastUser()
            LEFT JOIN Object AS Object_LastUser ON Object_LastUser.Id = ObjectLink_Client_LastUser.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_User_Unit
                                 ON ObjectLink_User_Unit.ObjectId = Object_LastUser.Id
                                AND ObjectLink_User_Unit.DescId   = zc_ObjectLink_User_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_User_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Client_InsertUnit
                                 ON ObjectLink_Client_InsertUnit.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_InsertUnit.DescId   = zc_ObjectLink_Client_InsertUnit()
            LEFT JOIN Object AS Object_Unit_Insert ON Object_Unit_Insert.Id = ObjectLink_Client_InsertUnit.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Protocol_Insert
                                 ON ObjectLink_Protocol_Insert.ObjectId = Object_Client.Id
                                AND ObjectLink_Protocol_Insert.DescId   = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_User_Insert ON Object_User_Insert.Id = ObjectLink_Protocol_Insert.ChildObjectId
            LEFT JOIN ObjectDate AS  ObjectDate_Protocol_Insert
                                  ON ObjectDate_Protocol_Insert.ObjectId = Object_Client.Id
                                 AND ObjectDate_Protocol_Insert.DescId   = zc_ObjectDate_Protocol_Insert()
            -- долг, движение
            LEFT JOIN tmpContainer ON tmpContainer.ClientId = Object_Client.Id
;
 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 23.04.187         *
*/

-- тест
--select * from gpSelect_Object_ClientBySMS(inStartDate := ('01.03.2017')::TDateTime , inEndDate := ('31.03.2017')::TDateTime , inUnitId := 4195 , inIsShowAll := False ,  inSession := '2');
--select * from gpSelect_Object_ClientBySMS(inStartDate := ('17.04.2018')::TDateTime , inEndDate := ('23.04.2018')::TDateTime , inUnitId := 1601 , inIsShowAll := 'TRUE' ,  inSession := '8') as tt
