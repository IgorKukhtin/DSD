DROP FUNCTION IF EXISTS gpSelect_Report_SoldDay (TDateTime, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Report_SoldDay (TDateTime, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Report_SoldDay (TDateTime, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_SoldDay(
    IN inMonth            TDateTime , -- ����� �����
    IN inUnitId           Integer   , -- �������������
    IN inQuasiSchedule    Boolean   , -- �������������
    IN inisNoStaticCodes  Boolean   , -- ��� ����������� �����
    IN inisSP             Boolean   , -- ��� ����� ������������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbTmpDate TDateTime;
   DECLARE vbDayInMonth TFloat;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
    vbStartDate := date_trunc('month', inMonth);
    vbEndDate := date_trunc('month', inMonth) + Interval '1 MONTH';
    vbDayInMonth := (vbEndDate::Date - vbStartDate::Date)::TFloat;

    -- ��������� ������������� �������������
    inUnitId := gpGet_CheckingUser_Unit(inUnitId, inSession);

    CREATE TEMP TABLE _TIME(
        PlanDate          TDateTime,  --����� �����
        DayOfWeek         Integer,    --���� � ������
        CountDay          NUMERIC(20,10)    --���-�� ����(������������� / ���������) � ������
        ) ON COMMIT DROP;
    CREATE TEMP TABLE _PartDay(
        PlanDate          TDateTime,  --����� �����
        DayOfWeek         Integer,    --���� � ������
        UnitId            Integer,
        Part              NUMERIC(20,10)
        ) ON COMMIT DROP;

    CREATE TEMP TABLE _TMP(
        PlanDate              TDateTime,  --����� �����
        DayOfWeek             Integer,    --���� � ������
        UnitId                Integer,    --�� �������������
        UnitName              TVarChar,   --�������������
        PlanMonthAmount       NUMERIC(20,10),     --���� � �����
        PlanAmount            NUMERIC(20,10),     --���� � ����
        PlanAmountAccum       NUMERIC(20,10),     --���� � �����������
        FactAmount            NUMERIC(20,10),     --���� � ����
        FactAmountAccum       NUMERIC(20,10),     --���� � �����������
        FactAmountSale        NUMERIC(20,10),     --���� � ����
        FactAmountSaleAccum   NUMERIC(20,10),     --���� � �����������
        FactAmountSaleIC      NUMERIC(20,10),     --���� � ����
        FactAmountSaleICAccum NUMERIC(20,10),     --���� � �����������
        DiffAmount            NUMERIC(20,10),     --������� (���� - ����)
        DiffAmountAccum       NUMERIC(20,10),     --������� � ���������� (���� � ����������� - ���� � �����������)
        PercentMake           NUMERIC(20,10),     --% ���������� �����
        PercentMakeAccum      NUMERIC(20,10)      --% ��������� �� ����������
    ) ON COMMIT DROP;

    --��������� ����� ����������
    vbTmpDate := vbStartDate;
    WHILE vbTmpDate < vbEndDate
    LOOP
        INSERT INTO _TIME(PlanDate,DayOfWeek)
        VALUES(vbTmpDate, date_part('dow', vbTmpDate));
        vbTmpDate := vbTmpDate + INTERVAL '1 DAY';
    END LOOP;

    UPDATE _TIME SET
        CountDay = (SELECT COUNT(*) FROM _TIME AS T1 WHERE T1.DayOfWeek = _TIME.DayOfWeek);

    INSERT INTO _TMP(PlanDate,DayOfWeek,UnitId,PlanMonthAmount)
    SELECT
        Object_ReportSoldParams.PlanDate::TDateTime       AS PlanDate,
        date_part('dow',Object_ReportSoldParams.PlanDate) AS DayOfWeek,
        Object_ReportSoldParams.UnitId                    AS UnitId,
        Object_ReportSoldParams.PlanAmount                AS PlanAmount
    FROM
        Object_ReportSoldParams_View AS Object_ReportSoldParams
    WHERE
        Object_ReportSoldParams.PlanDate >= vbStartDate
        AND
        Object_ReportSoldParams.PlanDate < vbEndDate
        AND
        (
            Object_ReportSoldParams.UnitId = inUnitId
            or
            inUnitId = 0
        );
        
     CREATE TEMP TABLE tmpMovement ON COMMIT DROP AS
     (SELECT       
           Movement.Id
         , Movement.InvNumber
         , Movement.OperDate
         , Movement.StatusId
         , Movement.DescId
         , MovementLinkObject_Unit.ObjectId           AS UnitId
         , MovementLinkObject_SPKind.ObjectId         AS SPKindId
         , MovementLinkObject_DiscountCard.ObjectId   AS DiscountCardId 

         , COALESCE(MovementFloat_TotalSumm.ValueData,0)::TFloat                   AS TotalSumm
         , COALESCE(MovementFloat_TotalSummSale.ValueData,0)::TFloat               AS TotalSummSale
         , COALESCE(MovementFloat_TotalSummChangePercent.ValueData,0)::TFloat      AS TotalSummChangePercent

     FROM Movement 

          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                  ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
          LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                  ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.Id
                                 AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()
          LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                  ON MovementFloat_TotalSummSale.MovementId = Movement.Id
                                 AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                       ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                      AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                       ON MovementLinkObject_DiscountCard.MovementId = Movement.Id
                                      AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
      WHERE Movement.DescId in (zc_Movement_Check(), zc_Movement_Sale())
        AND Movement.OperDate >= vbStartDate
        AND Movement.OperDate < vbEndDate
        AND Movement.StatusId = zc_Enum_Status_Complete()
        AND (MovementLinkObject_Unit.ObjectId = inUnitId or inUnitId = 0));        

    WITH tmpData AS (SELECT
                            date_trunc('day', MovementCheck.OperDate)::TDateTime  AS PlanDate,
                            date_part('dow',MovementCheck.OperDate)               AS DayOfWeek,
                            MovementCheck.UnitId                                  AS UnitID,
                            MovementCheck.TotalSumm                               AS FactAmount,
                            0.0::TFloat                                           AS FactAmountSale,
                            0.0::TFloat                                           AS FactAmountSaleIC
                     FROM tmpMovement AS MovementCheck
/*                          LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                                    ON MovementBoolean_CorrectMarketing.MovementId = MovementCheck.Id
                                                   AND MovementBoolean_CorrectMarketing.DescId in (zc_MovementBoolean_CorrectMarketing(), zc_MovementBoolean_CorrectIlliquidMarketing())
                                                   AND MovementBoolean_CorrectMarketing.ValueData = True*/
                     WHERE MovementCheck.DescId = zc_Movement_Check()
--                       AND COALESCE(MovementBoolean_CorrectMarketing.ValueData, False) = False
                       AND MovementCheck.Id NOT IN (22653173, 22653613, 22653819)
                     UNION ALL
                     SELECT
                            date_trunc('day', MovementSale.OperDate)::TDateTime  AS PlanDate,
                            date_part('dow',MovementSale.OperDate)               AS DayOfWeek,
                            MovementSale.UnitId                                  AS UnitID,
                            MovementSale.TotalSumm                               AS FactAmount,
                            MovementSale.TotalSumm                               AS FactAmountSale,
                            0.0::TFloat                                          AS FactAmountSaleIC
                     FROM tmpMovement AS MovementSale
                     WHERE MovementSale.DescId = zc_Movement_Sale()
                     UNION ALL
                     SELECT
                            date_trunc('day', MovementSale.OperDate)::TDateTime  AS PlanDate,
                            date_part('dow',MovementSale.OperDate)               AS DayOfWeek,
                            MovementSale.UnitId                                  AS UnitID,
                            0.0::TFloat                                          AS FactAmount,
                            0.0::TFloat                                          AS FactAmountSale,
                            MovementSale.TotalSummSale - MovementSale.TotalSumm  AS FactAmountSaleIC
                     FROM tmpMovement AS MovementSale
                     WHERE MovementSale.DescId = zc_Movement_Sale()
                       AND MovementSale.SPKindId = zc_enum_spkind_InsuranceCompanies()
             )
    
    INSERT INTO _TMP(PlanDate,DayOfWeek,UnitId,FactAmount,FactAmountSale,FactAmountSaleIC)
    SELECT
        Movement.PlanDate                                     AS PlanDate,
        Movement.DayOfWeek                                    AS DayOfWeek,
        Movement.UnitId                                       AS UnitID,
        COALESCE(SUM(Movement.FactAmount), 0)                 AS FactAmount,
        COALESCE(SUM(Movement.FactAmountSale), 0)             AS FactAmountSale,
        COALESCE(SUM(Movement.FactAmountSaleIC), 0)           AS FactAmountSaleIC
    FROM tmpData AS Movement
    GROUP BY Movement.PlanDate,
             Movement.DayOfWeek,
             Movement.UnitId;
                          
    IF COALESCE (inisSP, FALSE) = TRUE
    THEN
                      
       UPDATE _TMP SET FactAmount = _TMP.FactAmount + COALESCE (SP.Summa, 0)
                     , FactAmountSale = _TMP.FactAmountSale + COALESCE (SP.SummaSale, 0)
       FROM (WITH tmpData AS (SELECT
                                    date_trunc('day', MovementCheck.OperDate)::TDateTime  AS PlanDate,
                                    MovementCheck.UnitId                                  AS UnitID,
                                    MovementCheck.TotalSummChangePercent                  AS Summa,
                                    0.0::TFloat                                           AS SummaSale
                             FROM tmpMovement AS MovementCheck
/*                                  LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                                            ON MovementBoolean_CorrectMarketing.MovementId = MovementCheck.Id
                                                           AND MovementBoolean_CorrectMarketing.DescId in (zc_MovementBoolean_CorrectMarketing(), zc_MovementBoolean_CorrectIlliquidMarketing())
                                                           AND MovementBoolean_CorrectMarketing.ValueData = True*/
                             WHERE MovementCheck.DescId = zc_Movement_Check()
                               AND MovementCheck.SPKindId in (zc_Enum_SPKind_1303(), zc_Enum_SPKind_SP())
--                               AND COALESCE(MovementBoolean_CorrectMarketing.ValueData, False) = False
                               AND MovementCheck.Id NOT IN (22653173, 22653613, 22653819)
                             UNION ALL
                             SELECT
                                    date_trunc('day', MovementSale.OperDate)::TDateTime  AS PlanDate,
                                    MovementSale.UnitId                                  AS UnitID,
                                    MovementSale.TotalSummSale - MovementSale.TotalSumm  AS Summa,
                                    MovementSale.TotalSummSale - MovementSale.TotalSumm  AS SummaSale
                             FROM tmpMovement AS MovementSale
                             WHERE MovementSale.DescId = zc_Movement_Sale()
                               AND MovementSale.SPKindId in (zc_Enum_SPKind_1303(), zc_Enum_SPKind_SP())
                             UNION ALL
                             SELECT
                                    date_trunc('day', MovementCheck.OperDate)::TDateTime  AS PlanDate,
                                    MovementCheck.UnitId                                  AS UnitID,
                                    MovementCheck.TotalSummChangePercent                  AS Summa,
                                    0.0::TFloat                                           AS SummaSale
                             FROM tmpMovement AS MovementCheck
/*                                  LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                                            ON MovementBoolean_CorrectMarketing.MovementId = MovementCheck.Id
                                                           AND MovementBoolean_CorrectMarketing.DescId in (zc_MovementBoolean_CorrectMarketing(), zc_MovementBoolean_CorrectIlliquidMarketing())
                                                           AND MovementBoolean_CorrectMarketing.ValueData = True*/
                             WHERE MovementCheck.DescId = zc_Movement_Check()
                               AND COALESCE( MovementCheck.DiscountCardId, 0) <> 0
--                               AND COALESCE(MovementBoolean_CorrectMarketing.ValueData, False) = False
                               AND MovementCheck.Id NOT IN (22653173, 22653613, 22653819)
                             )

          SELECT Movement.PlanDate           AS PlanDate,
                 Movement.UnitId             AS UnitID,
                 SUM(Movement.Summa)         AS Summa,
                 SUM(Movement.SummaSale)     AS SummaSale
          FROM tmpData AS Movement
          GROUP BY Movement.PlanDate,
                   Movement.UnitId) AS SP
       WHERE _TMP.PlanDate = SP.PlanDate AND _TMP.UnitId = SP.UnitId;
    END IF;
        

    -- ������� ����������� ����
    IF inisNoStaticCodes = TRUE
    THEN

       UPDATE _TMP SET FactAmount = _TMP.FactAmount - COALESCE (StaticCodes.Summa, 0)
                     , FactAmountSale = _TMP.FactAmountSale - COALESCE (StaticCodes.SummaSale, 0)
       FROM (SELECT date_trunc('day', MovementItemContainer.OperDate)                             AS PlanDate
                   , Container.WhereObjectId                                                      AS UnitId
                   , SUM(ROUND(-1 * MovementItemContainer.Amount * MIFloat_Price.ValueData, 2))   AS Summa
                   , SUM(CASE WHEN MovementItemContainer.MovementDescId = zc_Movement_Sale() 
                              THEN ROUND(-1 * MovementItemContainer.Amount * MIFloat_Price.ValueData, 2) ELSE 0 END)   AS SummaSale
              FROM MovementItemContainer

                    INNER JOIN Container ON Container.ID = MovementItemContainer.ContainerID

                    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItemContainer.MovementItemId
                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                               
                    LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = Container.ObjectId

               WHERE MovementItemContainer.OperDate >= vbStartDate
                 AND MovementItemContainer.OperDate <= vbEndDate
                 AND MovementItemContainer.MovementDescId in (zc_Movement_Check(), zc_Movement_Sale())
                 AND MovementItemContainer.DescId = zc_MIContainer_Count()
                 AND (Container.WhereObjectId = inUnitId
                      or
                      inUnitId = 0)
                 AND Container.ObjectId IN (SELECT Object_Goods_Retail.ID
                                            FROM Object_Goods_Retail
                                            WHERE COALESCE (Object_Goods_Retail.SummaWages, 0) <> 0
                                               OR COALESCE (Object_Goods_Retail.PercentWages, 0) <> 0)
               GROUP BY date_trunc('day', MovementItemContainer.OperDate)
                      , Container.WhereObjectId) AS StaticCodes
       WHERE _TMP.PlanDate = StaticCodes.PlanDate AND _TMP.UnitId = StaticCodes.UnitId;

    END IF;


    --���� ����������� - ���������� ���� ���� � ������ �� ��������� 2 ������
    IF inQuasiSchedule = True THEN
        INSERT INTO _PartDay(PlanDate,DayOfWeek,UnitId,Part)
        SELECT
            _TIME.PlanDate,
            _TIME.DayOfWeek,
            UNIT.UnitId,
            COALESCE(COALESCE(SOLD.FactAmount,0) / SOLD.FactAmountUnit / _TIME.CountDay,0) AS PartDayOfWeek
        FROM
            _TIME
            CROSS JOIN (SELECT DISTINCT _TMP.UnitId FROM _Tmp) AS UNIT
            LEFT OUTER JOIN(SELECT
                                T0.DayOfWeek,
                                T0.UnitID,
                                T0.FactAmount,
                                SUM(T0.FactAmount)OVER(PARTITION BY T0.UnitId) AS FactAmountUnit
                            FROM(SELECT T1.DayOfWeek,
                                        T1.UnitID,
                                        SUM(T1.FactAmount)                         AS FactAmount
                                 FROM (
                                      SELECT
                                          date_part('dow', MovementCheck.OperDate) AS DayOfWeek,
                                          MovementCheck.UnitId                     AS UnitID,
                                          SUM(MovementCheck.TotalSumm)             AS FactAmount
                                      FROM
                                          tmpMovement AS MovementCheck
/*                                          LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                                                    ON MovementBoolean_CorrectMarketing.MovementId = MovementCheck.Id
                                                                   AND MovementBoolean_CorrectMarketing.DescId in (zc_MovementBoolean_CorrectMarketing(), zc_MovementBoolean_CorrectIlliquidMarketing())
                                                                   AND MovementBoolean_CorrectMarketing.ValueData = True*/
                                      WHERE
                                          MovementCheck.DescId = zc_Movement_Check()
/*                                          AND 
                                          COALESCE(MovementBoolean_CorrectMarketing.ValueData, False) = False*/
                                          AND 
                                          MovementCheck.Id NOT IN (22653173, 22653613, 22653819)
                                      GROUP BY
                                          date_part('dow', MovementCheck.OperDate),
                                          MovementCheck.UnitID
                                      UNION ALL
                                      SELECT
                                          date_part('dow', MovementSale.OperDate) AS DayOfWeek,
                                          MovementSale.UnitId                     AS UnitID,
                                          SUM(MovementSale.TotalSumm)             AS FactAmount
                                      FROM
                                          tmpMovement AS MovementSale
                                      WHERE
                                          MovementSale.DescId = zc_Movement_Sale()
                                      GROUP BY
                                          date_part('dow', MovementSale.OperDate),
                                          MovementSale.UnitID
                                      UNION ALL
                                      SELECT date_part('dow', MovementItemContainer.OperDate)                             AS PlanDate
                                           , Container.WhereObjectId                                                      AS UnitId
                                           , SUM(ROUND(-1 * MovementItemContainer.Amount * MIFloat_Price.ValueData, 2))   AS Summa
                                      FROM MovementItemContainer

                                           INNER JOIN Container ON Container.ID = MovementItemContainer.ContainerID

                                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                       ON MIFloat_Price.MovementItemId = MovementItemContainer.MovementItemId
                                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                                       
                                           LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = Container.ObjectId

                                       WHERE MovementItemContainer.OperDate >= (vbStartDate-INTERVAL '56 DAY')
                                         AND MovementItemContainer.OperDate < vbStartDate
                                         AND MovementItemContainer.MovementDescId in (zc_Movement_Check(), zc_Movement_Sale())
                                         AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                         AND (Container.WhereObjectId = inUnitId
                                              or
                                              inUnitId = 0)
                                         AND Container.ObjectId IN (SELECT Object_Goods_Retail.ID
                                                                     FROM Object_Goods_Retail
                                                                     WHERE COALESCE (Object_Goods_Retail.SummaWages, 0) <> 0
                                                                        OR COALESCE (Object_Goods_Retail.PercentWages, 0) <> 0)
                                         AND inisNoStaticCodes = TRUE
                                       GROUP BY date_part('dow', MovementItemContainer.OperDate)
                                              , Container.WhereObjectId) AS T1
                                 GROUP BY T1.DayOfWeek, T1.UnitID
                                ) AS T0
                            ) AS SOLD
                              ON _TIME.DayOfWeek = SOLD.DayOfWeek
                             AND UNIT.UnitId = SOLD.UnitId;


    ELSE --����� �������������
        INSERT INTO _PartDay(PlanDate,DayOfWeek,UnitId,Part)
        SELECT
            _TIME.PlanDate,
            _TIME.DayOfWeek,
            T.UnitId,
            100.0/vbDayInMonth/100.0 AS PartDayOfWeek
        FROM
            _TIME
            CROSS JOIN (SELECT DISTINCT
                                _TMP.UnitId
                            FROM
                                _Tmp
                        ) AS T;
    END IF;

    INSERT INTO _TMP(PlanDate,DayOfWeek,UnitId,PlanAmount)
    SELECT
        _TIME.PlanDate,
        _TIME.DayOfWeek,
        TMP.UnitId,
        TMP.PlanMonthAmount * COALESCE(_PartDay.Part,100.0/vbDayInMonth/100.0)
    FROM
        (SELECT * FROM _TMP WHERE _TMP.PlanMonthAmount is not null) AS TMP
        CROSS JOIN _TIME
        LEFT OUTER JOIN _PartDay ON TMP.UnitId = _PartDay.UnitId
                                AND _TIME.PlanDate = _PartDay.PlanDate;


     -- ���������
     OPEN Cursor1 FOR
        SELECT
            T0.PlanDate::TDateTime                                              AS PlanDate
           ,Object_Juridical.ValueData::TVarChar                                AS UnitJuridical
           ,Object_Unit.ValueData::TVarChar                                     AS UnitName
           ,Object_ProvinceCity.ValueData                                       AS ProvinceCityName
           ,ObjectHistory_JuridicalDetails.OKPO                                 AS OKPO

           ,T0.PlanAmount::TFloat                                               AS PlanAmount
           ,(SUM(T0.PlanAmount)OVER(PARTITION BY T0.UnitId
                                    ORDER BY T0.PlanDate))::TFloat              AS PlanAmountAccum
           ,T0.FactAmount::TFloat                                               AS FactAmount
           ,(SUM(T0.FactAmount)OVER(PARTITION BY T0.UnitId
                                    ORDER BY T0.PlanDate))::TFloat              AS FactAmountAccum
           ,T0.FactAmountSale::TFloat                                           AS FactAmountSale
           ,(SUM(T0.FactAmountSale)OVER(PARTITION BY T0.UnitId
                                    ORDER BY T0.PlanDate))::TFloat              AS FactAmountSaleAccum
           ,T0.FactAmountSaleIc::TFloat                                         AS FactAmountSaleIC
           ,(SUM(T0.FactAmountSaleIc)OVER(PARTITION BY T0.UnitId
                                    ORDER BY T0.PlanDate))::TFloat              AS FactAmountSaleICAccum
           ,T0.DiffAmount::TFloat                                               AS DiffAmount
           ,(SUM(T0.DiffAmount)OVER(PARTITION BY T0.UnitId
                                    ORDER BY T0.PlanDate))::TFloat              AS DiffAmountAccum
           ,CASE
                WHEN COALESCE(T0.PlanAmount,0)<>0
                    THEN 100.0*COALESCE(T0.FactAmount,0)/T0.PlanAmount
            END::TFloat                                                         AS PercentMake
           ,CASE
                WHEN COALESCE((SUM(T0.PlanAmount)OVER(PARTITION BY T0.UnitId
                                                      ORDER BY T0.PlanDate)),0)<>0
                    THEN 100.0
                        *(SUM(T0.DiffAmount)OVER(PARTITION BY T0.UnitId
                                                 ORDER BY T0.PlanDate))
                         /(SUM(T0.PlanAmount)OVER(PARTITION BY T0.UnitId
                                                  ORDER BY T0.PlanDate))
            END::TFloat                                                         AS PercentMakeAccum

        FROM(
            SELECT
                _PartDay.PlanDate
               ,_PartDay.UnitId
               ,COALESCE(SUM(_TMP.PlanAmount),0)    AS PlanAmount
               ,COALESCE(SUM(_TMP.FactAmount),0)     AS FactAmount
               ,COALESCE(SUM(_TMP.FactAmountSale),0) AS FactAmountSale
               ,COALESCE(SUM(_TMP.FactAmountSaleIC),0) AS FactAmountSaleIC
               ,COALESCE(SUM(_TMP.FactAmount),0)-COALESCE(SUM(_TMP.PlanAmount),0) AS DiffAmount
            FROM
                _PartDay
                LEFT OUTER JOIN _TMP ON _PartDay.PlanDate = _TMP.PlanDate
                                    AND _PartDay.UnitId = _TMP.UnitId
            GROUP BY
                _PartDay.PlanDate
               ,_PartDay.UnitId
           ) AS T0
           INNER JOIN Object AS Object_Unit ON T0.UnitId = Object_Unit.Id
           LEFT OUTER JOIN ObjectLink AS ObjectLinkJuridical
                                 ON Object_Unit.id = ObjectLinkJuridical.objectid
                                AND ObjectLinkJuridical.descid = zc_ObjectLink_Unit_Juridical()
           LEFT OUTER JOIN Object AS Object_Juridical ON Object_Juridical.id = ObjectLinkJuridical.childobjectid

           LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
           LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId
           
           LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := ObjectLinkJuridical.childobjectid, inFullName := '', inOKPO := '', inSession := '3') AS ObjectHistory_JuridicalDetails ON 1=1           
       ORDER BY
           Object_Unit.ValueData
          ,T0.PlanDate;
     RETURN NEXT Cursor1;
     
     -- ���������
     OPEN Cursor2 FOR
       SELECT
           _PartDay.PlanDate
          ,COALESCE(SUM(_TMP.FactAmount),0)     AS FactAmount
       FROM
           _PartDay
           LEFT OUTER JOIN _TMP ON _PartDay.PlanDate = _TMP.PlanDate
                               AND _PartDay.UnitId = _TMP.UnitId
       WHERE _PartDay.PlanDate <= CURRENT_DATE
       GROUP BY
           _PartDay.PlanDate
       ORDER BY
           _PartDay.PlanDate;
     RETURN NEXT Cursor2;
          
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

ALTER FUNCTION gpSelect_Report_SoldDay (TDateTime, Integer, Boolean, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�. ������ �.�.
 24.02.21                                                                                     *
 30.05.19         *
 21.06.15                                                                                     *
 31.03.15                                                                                     *
 28.09.15                                                                        *
*/


select * from gpSelect_Report_SoldDay(inMonth := ('06.04.2023')::TDateTime , inUnitId := 183289 , inQuasiSchedule := 'False' , inisNoStaticCodes := 'True' , inisSP := 'True' ,  inSession := '3');

