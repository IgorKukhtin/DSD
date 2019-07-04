-- Function: gpGet_ScaleCeh_GoodsSeparate()

DROP FUNCTION IF EXISTS gpGet_ScaleCeh_GoodsSeparate (TDateTime, Integer, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ScaleCeh_GoodsSeparate(
    IN inOperDate              TDateTime   , --
    IN inMovementId            Integer     , --
    IN inGoodsId               Integer     , --
    IN inPartionGoods          TVarChar    , --
    IN inIsClose               Boolean     , --
    IN inSession               TVarChar      -- сессия пользователя
)
RETURNS TABLE (MovementId          Integer
             , StatusId            Integer
             , StatusName          TVarChar
             , InvNumber           TVarChar
             , OperDate            TDateTime
             , PartionGoods        TVarChar
             , PartionGoods_calc   TVarChar
             , FromId              Integer
             , FromName            TVarChar
             , ToId                Integer
             , ToName              TVarChar

             , TotalCount_null     TFloat
             , TotalCount_MO       TFloat
             , TotalCount_OB       TFloat
             , TotalCount_PR       TFloat
             , TotalCount_P        TFloat
             , TotalCount_in       TFloat   -- все кол-во, которое будет распределяться: или из Обв-приход или из текущего взвешивания

             , HeadCount_null      TFloat
             , HeadCount_MO        TFloat
             , HeadCount_OB        TFloat
             , HeadCount_PR        TFloat
             , HeadCount_P         TFloat
             , HeadCount_in        TFloat   -- все кол-во, которое будет распределяться: или из Обв-приход или из текущего взвешивания

             , TotalCount_isOpen   TFloat
             , HeadCount_isOpen    TFloat

             , PartionGoods_null   TVarChar
             , PartionGoods_MO     TVarChar
             , PartionGoods_OB     TVarChar
             , PartionGoods_PR     TVarChar
             , PartionGoods_P      TVarChar
              )
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbPartionGoods_calc TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- <преобразовали партию>
    vbPartionGoods_calc:= zfFormat_PartionGoods (inPartionGoods);
                        /*zfCalc_PartionGoods (inGoodsCode  := zfCalc_PartionGoods_GoodsCode (inPartionGoods)
                                             , inPartnerCode:= zfCalc_PartionGoods_PartnerCode (inPartionGoods)
                                             , inOperDate   := zfCalc_PartionGoods_OperDate (inPartionGoods)
                                              );*/

    -- Результат
    RETURN QUERY
       WITH tmpMovement AS (-- расходы партии по категориям + итого приход
                            SELECT Movement.Id                           AS Id
                                 , Movement.StatusId                     AS StatusId
                                 , Movement.InvNumber                    AS InvNumber
                                 , Movement.OperDate                     AS OperDate
                                 , MovementString_PartionGoods.ValueData AS PartionGoods
                                 , MovementLinkObject_From.ObjectId      AS FromId
                                 , MovementLinkObject_To.ObjectId        AS ToId

                                 , SUM (CASE WHEN MovementString_PartionGoods.ValueData ILIKE ('МО%')
                                              AND MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END) AS TotalCount_MO
                                 , SUM (CASE WHEN MovementString_PartionGoods.ValueData ILIKE ('МО%')
                                              AND MovementItem.DescId = zc_MI_Master() THEN COALESCE (MIFloat_HeadCount.ValueData, 0) ELSE 0 END) AS HeadCount_MO

                                 , SUM (CASE WHEN MovementString_PartionGoods.ValueData ILIKE ('ОБ%')
                                              AND MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END) AS TotalCount_OB
                                 , SUM (CASE WHEN MovementString_PartionGoods.ValueData ILIKE ('ОБ%')
                                              AND MovementItem.DescId = zc_MI_Master() THEN COALESCE (MIFloat_HeadCount.ValueData, 0) ELSE 0 END) AS HeadCount_OB

                                 , SUM (CASE WHEN MovementString_PartionGoods.ValueData ILIKE ('ПР%')
                                              AND MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END) AS TotalCount_PR
                                 , SUM (CASE WHEN MovementString_PartionGoods.ValueData ILIKE ('ПР%')
                                              AND MovementItem.DescId = zc_MI_Master() THEN COALESCE (MIFloat_HeadCount.ValueData, 0) ELSE 0 END) AS HeadCount_PR

                                 , SUM (CASE WHEN MovementString_PartionGoods.ValueData ILIKE ('ПР%')
                                              AND MovementItem.DescId = zc_MI_Master() THEN 0
                                             WHEN MovementString_PartionGoods.ValueData ILIKE ('П%')
                                              AND MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END) AS TotalCount_P
                                 , SUM (CASE WHEN MovementString_PartionGoods.ValueData ILIKE ('ПР%')
                                              AND MovementItem.DescId = zc_MI_Master() THEN 0
                                             WHEN MovementString_PartionGoods.ValueData ILIKE ('П%')
                                              AND MovementItem.DescId = zc_MI_Master() THEN COALESCE (MIFloat_HeadCount.ValueData, 0) ELSE 0 END) AS HeadCount_P

                                 , SUM (CASE WHEN (MovementString_PartionGoods.ValueData ILIKE ('МО%')
                                                OR MovementString_PartionGoods.ValueData ILIKE ('ОБ%')
                                                OR MovementString_PartionGoods.ValueData ILIKE ('П%'))
                                              AND MovementItem.DescId = zc_MI_Master() THEN 0
                                             WHEN MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END) AS TotalCount_null
                                 , SUM (CASE WHEN (MovementString_PartionGoods.ValueData ILIKE ('МО%')
                                                OR MovementString_PartionGoods.ValueData ILIKE ('ОБ%')
                                                OR MovementString_PartionGoods.ValueData ILIKE ('П%'))
                                              AND MovementItem.DescId = zc_MI_Master() THEN 0
                                             WHEN MovementItem.DescId = zc_MI_Master() THEN COALESCE (MIFloat_HeadCount.ValueData, 0) ELSE 0 END) AS HeadCount_null

                                   -- точно соответствует партии
                                 , SUM (CASE WHEN inIsClose = TRUE AND MovementString_PartionGoods.ValueData ILIKE (vbPartionGoods_calc)
                                              AND MovementItem.DescId = zc_MI_Child()  THEN MovementItem.Amount ELSE 0 END) AS TotalCount_in
                                   -- точно соответствует партии
                                 , SUM (CASE WHEN inIsClose = TRUE AND MovementString_PartionGoods.ValueData ILIKE (vbPartionGoods_calc)
                                              AND MovementItem.DescId = zc_MI_Child()  THEN COALESCE (MIFloat_HeadCount.ValueData, 0) ELSE 0 END) AS HeadCount_in

                                 , 0 AS TotalCount_isOpen
                                 , 0 AS HeadCount_isOpen

                             FROM Movement
                                  LEFT JOIN MovementString AS MovementString_PartionGoods
                                                           ON MovementString_PartionGoods.MovementId =  Movement.Id
                                                          AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      -- AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.ObjectId   = inGoodsId
                                                         AND MovementItem.isErased   = FALSE
                                  LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                              ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                             AND MIFloat_HeadCount.DescId         = zc_MIFloat_HeadCount()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                             WHERE Movement.OperDate BETWEEN inOperDate - (CASE WHEN vbUserId = 5 THEN '3' ELSE '0' END ||  ' DAY') :: INTERVAL AND inOperDate
                               AND Movement.DescId   = zc_Movement_ProductionSeparate()
                               AND Movement.StatusId <> zc_Enum_Status_Erased()
                               AND MovementString_PartionGoods.ValueData ILIKE ('%' || vbPartionGoods_calc || '%')
                             GROUP BY Movement.Id
                                    , Movement.StatusId
                                    , Movement.InvNumber
                                    , Movement.OperDate
                                    , MovementString_PartionGoods.ValueData
                                    , MovementLinkObject_From.ObjectId
                                    , MovementLinkObject_To.ObjectId
                           UNION ALL
                            -- все что в документе inMovementId = тоже приход по партии
                            SELECT Movement.Id                           AS Id
                                 , Movement.StatusId                     AS StatusId
                                 , Movement.InvNumber                    AS InvNumber
                                 , Movement.OperDate                     AS OperDate
                                 , MIString_PartionGoods.ValueData       AS PartionGoods
                                 , MovementLinkObject_From.ObjectId      AS FromId
                                 , MovementLinkObject_To.ObjectId        AS ToId
                                 , 0 AS TotalCount_MO
                                 , 0 AS HeadCount_MO
                                 , 0 AS TotalCount_OB
                                 , 0 AS HeadCount_OB
                                 , 0 AS TotalCount_PR
                                 , 0 AS HeadCount_PR
                                 , 0 AS TotalCount_P
                                 , 0 AS HeadCount_P
                                 , 0 AS TotalCount_null
                                 , 0 AS HeadCount_null
                                 , SUM (MovementItem.Amount)                       AS TotalCount_in
                                 , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0)) AS HeadCount_in
                                 , SUM (CASE WHEN MIBoolean_isAuto.ValueData = TRUE THEN 0 ELSE MovementItem.Amount                       END) AS TotalCount_isOpen
                                 , SUM (CASE WHEN MIBoolean_isAuto.ValueData = TRUE THEN 0 ELSE COALESCE (MIFloat_HeadCount.ValueData, 0) END) AS HeadCount_isOpen

                             FROM Movement
                                  INNER JOIN MovementBoolean AS MovementBoolean_isIncome
                                                             ON MovementBoolean_isIncome.MovementId =  Movement.Id
                                                            AND MovementBoolean_isIncome.DescId     = zc_MovementBoolean_isIncome()
                                                            AND MovementBoolean_isIncome.ValueData  = TRUE
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.ObjectId   = inGoodsId
                                                         AND MovementItem.isErased   = FALSE
                                  LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                                                ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                                               AND MIBoolean_isAuto.DescId         = zc_MIBoolean_isAuto()
                                  LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                              ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                             AND MIFloat_HeadCount.DescId         = zc_MIFloat_HeadCount()
                                  INNER JOIN MovementItemString AS MIString_PartionGoods
                                                                ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                               AND MIString_PartionGoods.DescId         = zc_MIString_PartionGoods()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                             WHERE Movement.Id = inMovementId
                               -- точно соответствует партии
                               AND MIString_PartionGoods.ValueData ILIKE (inPartionGoods)
                            -- AND MIString_PartionGoods.ValueData ILIKE (vbPartionGoods_calc)
                               AND inIsClose = FALSE
                            GROUP BY Movement.Id
                                   , Movement.StatusId
                                   , Movement.InvNumber
                                   , Movement.OperDate
                                   , MIString_PartionGoods.ValueData
                                   , MovementLinkObject_From.ObjectId
                                   , MovementLinkObject_To.ObjectId
                           )
       -- Результат
       SELECT tmpMovement.Id                        AS MovementId
            , tmpMovement.StatusId                  AS StatusId
            , Object_Status.ValueData               AS StatusName
            , tmpMovement.InvNumber                 AS InvNumber
            , tmpMovement.OperDate                  AS OperDate

            , tmpMovement.PartionGoods              AS PartionGoods
            , tmp.PartionGoods_calc                 AS PartionGoods_calc

            , Object_From.Id                        AS FromId
            , Object_From.ValueData                 AS FromName
            , Object_To.Id                          AS ToId
            , Object_To.ValueData                   AS ToName

            , tmpMovement.TotalCount_null :: TFloat AS TotalCount_null
            , tmpMovement.TotalCount_MO   :: TFloat AS TotalCount_MO
            , tmpMovement.TotalCount_OB   :: TFloat AS TotalCount_OB
            , tmpMovement.TotalCount_PR   :: TFloat AS TotalCount_PR
            , tmpMovement.TotalCount_P    :: TFloat AS TotalCount_P
            , tmpMovement.TotalCount_in   :: TFloat AS TotalCount_in
            
            , tmpMovement.HeadCount_null  :: TFloat AS HeadCount_null
            , tmpMovement.HeadCount_MO    :: TFloat AS HeadCount_MO
            , tmpMovement.HeadCount_OB    :: TFloat AS HeadCount_OB
            , tmpMovement.HeadCount_PR    :: TFloat AS HeadCount_PR
            , tmpMovement.HeadCount_P     :: TFloat AS HeadCount_P
            , tmpMovement.HeadCount_in    :: TFloat AS HeadCount_in

            , tmpMovement.TotalCount_isOpen    :: TFloat   AS TotalCount_isOpen
            , tmpMovement.HeadCount_isOpen     :: TFloat   AS HeadCount_isOpen

            , tmp.PartionGoods_calc            :: TVarChar AS PartionGoods_null
            , ('мо-' || tmp.PartionGoods_calc) :: TVarChar AS PartionGoods_MO
            , ('об-' || tmp.PartionGoods_calc) :: TVarChar AS PartionGoods_OB
            , ('пр-' || tmp.PartionGoods_calc) :: TVarChar AS PartionGoods_PR
            , ('п-'  || tmp.PartionGoods_calc) :: TVarChar AS PartionGoods_P

       FROM (SELECT vbPartionGoods_calc AS PartionGoods_calc) AS tmp
            LEFT JOIN tmpMovement ON tmpMovement.Id > 0
            LEFT JOIN Object AS Object_From   ON Object_From.Id   = tmpMovement.FromId
            LEFT JOIN Object AS Object_To     ON Object_To.Id     = tmpMovement.ToId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMovement.StatusId
            LEFT JOIN MovementBoolean AS MovementBoolean_isIncome
                                      ON MovementBoolean_isIncome.MovementId =  tmpMovement.Id
                                     AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()
            LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                    ON MovementFloat_MovementDescNumber.MovementId =  tmpMovement.Id
                                   AND MovementFloat_MovementDescNumber.DescId     = zc_MovementFloat_MovementDescNumber()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.19                                        *
*/

-- тест
-- SELECT * FROM gpGet_ScaleCeh_GoodsSeparate (inOperDate:= '25.06.2019', inMovementId:= 1, inGoodsId:= 4261, inPartionGoods:= 'мо-4218-11956-25.06.2019', inIsClose:= FALSE, inSession:= zfCalc_UserAdmin()) -- 4134;"СВИНИНА н/к в/ш 2кат_*"
