-- Function: gpUpdate_MI_OrderIncomeSnab()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderIncomeSnab (Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderIncomeSnab(
    IN inMovementId         Integer   , -- Ключ объекта <Документ>
 INOUT ioStartDate          TDateTime , --
 INOUT ioEndDate            TDateTime , --
    IN inUnitId             Integer,    -- подразделение склад
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId_From Integer;
   DECLARE vbOperDate TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderIncome());

    -- определяем поставщика из документа
    vbJuridicalId_From := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Juridical());

    -- проверка - свойство должно быть установлено
    IF COALESCE (vbJuridicalId_From, 0) = 0 THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Юр.лицо (поставщик)>.';
    END IF;

    -- определяем из документа
    vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);


    -- переопределяем даты для расчета данных - ПОЛНЫЕ (с пон - по вск) - ЗАВЕРШЕННЫЕ 4 недели
    ioEndDate := CASE WHEN vbOperDate > CURRENT_DATE 
                      THEN -- если Дата документа БОЛЬШЕ сегодняшней
                           CASE WHEN EXTRACT (DOW FROM CURRENT_DATE) = 0
                                             THEN CURRENT_DATE -- Если СЕГОДНЯ = вскр.
                                     -- иначе находим ближайшее ПРОШЕДШЕЕ вскр. от СЕГОДНЯ
                                     ELSE (CURRENT_DATE - ((EXTRACT (DOW FROM CURRENT_DATE)) :: TVarChar || ' DAY') :: INTERVAL)
                           END
                      ELSE CASE WHEN EXTRACT (DOW FROM vbOperDate) = 0
                                     THEN vbOperDate -- Если ДАТА = вскр.
                                -- иначе находим ближайшее ПРОШЕДШЕЕ вскр. от ДАТЫ
                                ELSE (vbOperDate - ((EXTRACT (DOW FROM vbOperDate)) :: TVarChar || ' DAY') :: INTERVAL)
                           END
                 END;
    -- начальная будет пнд. - 4 недели НАЗАД
    ioStartDate := ioEndDate - INTERVAL '27 DAY';


    -- рассчетные данные !!!до ДАТЫ документа!!!
    PERFORM lpInsertUpdate_MI_OrderIncomeSnab_Property
                                                   (inId              := tmpData.MovementItemId
                                                  , inMovementId      := inMovementId
                                                  , inGoodsId         := tmpData.GoodsId
                                                  , inMeasureId       := ObjectLink_Goods_Measure.ChildObjectId
                                                  , inRemainsStart    := COALESCE (tmpData.RemainsStart, 0)
                                                  , inBalanceStart    := COALESCE (tmpData.RemainsStart_Oth, 0)
                                                  , inBalanceEnd      := COALESCE (tmpData.RemainsEnd_Oth, 0)
                                                  , inIncome          := COALESCE (tmpData.CountIncome, 0)
                                                  , inAmountForecast  := COALESCE (tmpData.CountProductionOut, 0)
                                                  , inAmountIn        := COALESCE (tmpData.CountIn_oth, 0)
                                                  , inAmountOut       := COALESCE (tmpData.CountOut_oth, 0)
                                                  , inAmountOrder     := COALESCE (tmpData.CountOrder, 0)
                                                  , inUserId          := vbUserId
                                                    )
      FROM (WITH tmpMI AS (SELECT MovementItem.Id              AS MovementItemId
                                , MILinkObject_Goods.ObjectId  AS GoodsId
                           FROM MovementItem
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                 ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
           , tmpReport AS (SELECT gpReport.GoodsId
                                , gpReport.RemainsStart
                                , gpReport.RemainsStart_Oth
                                , gpReport.RemainsEnd_Oth 
                                , gpReport.CountIncome
                                , gpReport.CountProductionOut
                                , gpReport.CountIn_oth
                                , gpReport.CountOut_oth
                                , gpReport.CountOrder
                           FROM gpReport_SupplyBalance (inStartDate   := ioStartDate
                                                      , inEndDate     := vbOperDate -- !!!последняя дата - ДАТА документа!!!
                                                      , inUnitId      := 8455
                                                      , inGoodsGroupId:= 0
                                                      , inJuridicalId := vbJuridicalId_From
                                                      , inSession     := inSession
                                                       ) AS gpReport
                          )
            -- Результат
            SELECT tmpMI.MovementItemId
                  , COALESCE (tmpMI.GoodsId, tmpReport.GoodsId) AS GoodsId
                  , tmpReport.RemainsStart
                  , tmpReport.RemainsStart_Oth
                  , tmpReport.RemainsEnd_Oth 
                  , tmpReport.CountIncome
                  , tmpReport.CountProductionOut
                  , tmpReport.CountIn_oth
                  , tmpReport.CountOut_oth
                  , tmpReport.CountOrder
            FROM tmpMI
                 FULL JOIN tmpReport ON tmpReport.GoodsId = tmpMI.GoodsId
           ) AS tmpData
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                ON ObjectLink_Goods_Measure.ObjectId = tmpData.GoodsId
                               AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 31.05.17         *
 04.05.17         *
 18.04.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_OrderIncomeSnab(ioStartDate := ('01.12.2016')::TDateTime , ioEndDate := ('21.12.2016')::TDateTime , inUnitId := 8455 , inGoodsGroupId := 1917 ,  inSession := '5');
