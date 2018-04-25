-- Function: gpGet_Movement_ReturnIn (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_ReturnIn (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ReturnIn (Integer, TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ReturnIn(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inStartDate         TDateTime, -- 
    IN inEndDate           TDateTime, -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , LastDate TDateTime, StartDate TDateTime, EndDate TDateTime
             , TotalSumm TFloat, TotalSummPay TFloat, TotalDebt TFloat
             , DiscountTax TFloat, DiscountTaxTwo TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , HappyDate TDateTime
             , PhoneMobile TVarChar, Phone TVarChar
             , Comment TVarChar, Comment_Client TVarChar
             , InsertName TVarChar, InsertDate TDateTime
               )
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbUnitId_User Integer;
   DECLARE vbUnitId      Integer;
   DECLARE vbClientId    Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);


     -- для Пользователя - к какому Подразделению он привязан
     vbUnitId_User:= lpGetUnit_byUser (vbUserId);


     -- заменили
     IF inOperDate < '01.01.2017' OR vbUnitId_User > 0 OR 1=1 THEN inOperDate:= CURRENT_DATE; END IF;

     -- пытаемся найти последний непроведенный документ
     IF COALESCE (inMovementId, 0) = 0
     THEN
         inMovementId:= (SELECT tmp.Id
                         FROM (SELECT Movement.Id
                                    , ROW_NUMBER() OVER (ORDER BY Movement.Operdate DESC, Movement.Id DESC) AS Ord
                               FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                           AND MovementLinkObject_To.ObjectId = vbUnitId_User
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                               WHERE Movement.DescId   = zc_Movement_ReturnIn()
                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                 AND Movement.OperDate = CURRENT_DATE
                               ) AS tmp
                         WHERE tmp.Ord = 1);
     END IF;
     
     
     IF COALESCE (inMovementId, 0) = 0
     THEN
         -- Результат
         RETURN QUERY 
         SELECT
               0 AS Id
             , CAST (lfGet_InvNumber (0, zc_Movement_ReturnIn()) AS TVarChar) AS InvNumber
             , inOperDate                       AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName
            
             , CAST (NULL AS TDateTime)         AS LastDate
             , (inOperDate - INTERVAL '8 MONTH') :: TDateTime AS StartDate
             , (inOperDate - INTERVAL '0 DAY')   :: TDateTime AS EndDate
             , CAST (0 as TFloat)               AS TotalSumm
             , CAST (0 as TFloat)               AS TotalSummPay
             , CAST (0 as TFloat)               AS TotalDebt
             , CAST (0 as TFloat)               AS DiscountTax
             , CAST (0 as TFloat)               AS DiscountTaxTwo

             , 0                                AS FromId
             , CAST ('' as TVarChar)            AS FromName
                          
             , Object_Unit.Id                                   AS ToId
             , COALESCE (Object_Unit.ValueData, '') :: TVarChar AS ToName
           
             , CAST (NULL AS TDateTime)         AS HappyDate	
             , CAST ('' as TVarChar)            AS PhoneMobile
             , CAST ('' as TVarChar)            AS Phone
             , CAST ('' as TVarChar)            AS Comment
             , CAST ('' as TVarChar)            AS Comment_Client

             , COALESCE(Object_Insert.ValueData,'')  ::TVarChar AS InsertName
             , CURRENT_TIMESTAMP ::TDateTime    AS InsertDate
             
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = vbUnitId_User;
     ELSE

       -- параметры из Документа
       SELECT MovementLinkObject_From.ObjectId AS ClientId
            , MovementLinkObject_To.ObjectId   AS UnitId
              INTO vbClientId, vbUnitId
       FROM MovementLinkObject AS MovementLinkObject_From
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = MovementLinkObject_From.MovementId
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
       WHERE MovementLinkObject_From.MovementId = inMovementId
         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();

       -- проверка может ли смотреть любой магазин, или только свой
       PERFORM lpCheckUnit_byUser (inUnitId_by:= vbUnitId, inUserId:= vbUserId);
     

       -- Результат
       RETURN QUERY 
           WITH
           -- выбираю все контейнеры по покупателю и подразделению , если выбрано 
           tmpContainer AS (SELECT CLO_PartionMI.ObjectId          AS PartionId_MI
                                 , Container.Amount
                            FROM Container
                                 INNER JOIN ContainerLinkObject AS CLO_Client 
                                                                ON CLO_Client.ContainerId = Container.Id
                                                               AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                               AND CLO_Client.ObjectId    = vbClientId                            --inClientId --Перцева Наталья 6343  -- 
                                 INNER JOIN ContainerLinkObject AS CLO_Unit 
                                                                ON CLO_Unit.ContainerId = Container.Id
                                                               AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                               AND CLO_Unit.ObjectId    = vbUnitId
                                 LEFT JOIN ContainerLinkObject AS CLO_PartionMI 
                                                               ON CLO_PartionMI.ContainerId = Container.Id
                                                              AND CLO_PartionMI.DescId      = zc_ContainerLinkObject_PartionMI()
                             -- !!!кроме Покупатели + Прибыль будущих периодов!!!
                             WHERE Container.ObjectId <> zc_Enum_Account_20102() 
                               AND Container.DescId  = zc_Container_Summ()                         
                           ) 
         -- получили конечный долг и у нас все партии продажи
         , tmpPartion AS (SELECT tmpContainer.PartionId_MI
                               , sum(tmpContainer.Amount) OVER () as SummDedt
                          FROM tmpContainer
                          )                     
          -- расчет суммы продаж и оплат по партии продажи
         , tmpData AS (SELECT tmpData.SummDedt AS SummDedt
                            , SUM ((MI_PartionMI.Amount * MIFloat_OperPriceList.ValueData)
                                  - COALESCE (MIFloat_TotalReturn.ValueData, 0) 
                                  - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) 
                                  - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                  )   AS TotalSumm
                                   
                            , SUM (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0) - COALESCE (MIFloat_TotalPayReturn.ValueData, 0)) AS TotalPay
                            , MAX (Movement_PartionMI.Operdate) AS LastDate
                       FROM (SELECT DISTINCT tmpPartion.PartionId_MI , tmpPartion.SummDedt  FROM tmpPartion) AS tmpData
                           
                           LEFT JOIN Object AS Object_PartionMI     ON Object_PartionMI.Id     = tmpData.PartionId_MI
                           LEFT JOIN MovementItem AS MI_PartionMI   ON MI_PartionMI.Id         = Object_PartionMI.ObjectCode
                           LEFT JOIN Movement AS Movement_PartionMI ON Movement_PartionMI.Id   = MI_PartionMI.MovementId 

                           LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                       ON MIFloat_OperPriceList.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()                             

                           LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                       ON MIFloat_TotalCountReturn.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()

                           LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                               ON MIFloat_TotalChangePercent.MovementItemId = MI_PartionMI.Id
                                              AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()

                           LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                       ON MIFloat_TotalChangePercentPay.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                           LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                       ON MIFloat_TotalPay.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                           LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                       ON MIFloat_TotalPayOth.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

                           LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                       ON MIFloat_TotalPayReturn.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()
                           LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                       ON MIFloat_TotalReturn.MovementItemId = MI_PartionMI.Id
                                                      AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                       GROUP BY tmpData.SummDedt 
                       )
         -- Результат
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode               AS StatusCode
             , Object_Status.ValueData                AS StatusName
             
             , tmpData.LastDate                         :: TDateTime AS LastDate
             , COALESCE (inStartDate, (Movement.OperDate - INTERVAL '8 MONTH')) :: TDateTime AS StartDate
             , COALESCE (inEndDate, (Movement.OperDate - INTERVAL '0 DAY'))     :: TDateTime AS EndDate

             , COALESCE (tmpData.TotalSumm, 0) :: TFloat AS TotalSumm
             , COALESCE (tmpData.TotalPay, 0)  :: TFloat AS TotalSummPay
             , COALESCE (tmpData.SummDedt, 0)  :: TFloat AS TotalDebt
             , ObjectFloat_DiscountTax.ValueData         AS DiscountTax
             , ObjectFloat_DiscountTaxTwo.ValueData      AS DiscountTaxTwo

             , Object_From.Id                         AS FromId
             , Object_From.ValueData                  AS FromName
             , Object_To.Id                           AS ToId
             , Object_To.ValueData                    AS ToName
           
             , ObjectDate_HappyDate.ValueData         AS HappyDate
             , ObjectString_PhoneMobile.ValueData     AS PhoneMobile
             , ObjectString_Phone.ValueData           AS Phone

             , MovementString_Comment.ValueData       AS Comment
             , ObjectString_Comment.ValueData         AS Comment_Client
             
             , Object_Insert.ValueData                AS InsertName
             , COALESCE (MovementDate_Insert.ValueData, CURRENT_TIMESTAMP)  :: TDateTime AS InsertDate
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
    
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax 
                                  ON ObjectFloat_DiscountTax.ObjectId = Object_From.Id 
                                 AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Client_DiscountTax()

            LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTaxTwo 
                                  ON ObjectFloat_DiscountTaxTwo.ObjectId = Object_From.Id
                                 AND ObjectFloat_DiscountTaxTwo.DescId = zc_ObjectFloat_Client_DiscountTaxTwo()

            LEFT JOIN ObjectString AS  ObjectString_Comment 
                                   ON  ObjectString_Comment.ObjectId = Object_From.Id
                                  AND  ObjectString_Comment.DescId = zc_ObjectString_Client_Comment()

            LEFT JOIN ObjectFloat AS ObjectFloat_TotalSummDiscount
                                  ON ObjectFloat_TotalSummDiscount.ObjectId = Object_From.Id
                                 AND ObjectFloat_TotalSummDiscount.DescId = zc_ObjectFloat_Client_TotalSummDiscount()
                                 
            LEFT JOIN ObjectDate AS ObjectDate_HappyDate 
                                 ON ObjectDate_HappyDate.ObjectId = Object_From.Id 
                                AND ObjectDate_HappyDate.DescId = zc_ObjectDate_Client_HappyDate()

            LEFT JOIN ObjectString AS ObjectString_PhoneMobile 
                                   ON ObjectString_PhoneMobile.ObjectId = Object_From.Id 
                                  AND ObjectString_PhoneMobile.DescId = zc_ObjectString_Client_PhoneMobile()

            LEFT JOIN ObjectString AS ObjectString_Phone 
                                   ON ObjectString_Phone.ObjectId = Object_From.Id 
                                  AND ObjectString_Phone.DescId = zc_ObjectString_Client_Phone()
            LEFT JOIN tmpData ON 1 = 1
       WHERE Movement.Id     = inMovementId
         AND Movement.DescId = zc_Movement_ReturnIn()
        ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 24.03.18         *
 19.02.18         *
 12.02.18         *
 15.05.17         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ReturnIn (inMovementId:= 1, inOperDate:= CURRENT_DATE, inStartDate:= '01.02.2017'::TDateTime, inEndDate:= '01.03.2017'::TDateTime, inSession:= zfCalc_UserAdmin())
