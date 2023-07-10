-- Function: gpComplete_SelectAll_Sybase_ALL()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase (TDateTime, TDateTime, Boolean, Boolean);
DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase (TDateTime, TDateTime, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsSale             Boolean   , --
    IN inIsBefoHistoryCost  Boolean   , --
    IN inGroupId            Integer     -- -1:��� 0:�.����� 1:�.���� 2:��������� �������
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, ItemName TVarChar, BranchCode Integer, BranchName TVarChar
              )
AS
$BODY$
  DECLARE vbIsSale Boolean;
  DECLARE vbIsReturnIn Boolean;
BEGIN


IF inIsBefoHistoryCost = TRUE
THEN
    inGroupId:= -1;
-- ELSE
--    inGroupId:= -1; -- ���
--  inGroupId:=  0; -- �.�����
--  inGroupId:=  1; -- �.����
--  inGroupId:=  2; -- ������ ������
--  inGroupId:=  3; -- ��������� �������
--  inGroupId:=  4; -- �������/������� - �.�����
END IF;


-- inIsBefoHistoryCost:= TRUE;


     -- !!!����� �� �������!!!
     vbIsSale:= -- ���� ��������� 1 ���� ������
                DATE_TRUNC ('MONTH', CURRENT_DATE + INTERVAL '1 DAY')  > (DATE_TRUNC ('MONTH', CURRENT_DATE))
                -- ��� ������� ������
             OR DATE_TRUNC ('MONTH', inStartDate) < (DATE_TRUNC ('MONTH', CURRENT_DATE))
                -- ��� �������
             OR EXTRACT (DOW FROM CURRENT_DATE) = 6
                -- ���
             OR EXTRACT (DAY FROM CURRENT_DATE) <= 15
           --OR 1=1
             OR inGroupId = 4
                ;

     -- !!!����� �� ��������!!!
     vbIsReturnIn:= -- ���� ��������� 2 ��� ������
                    DATE_TRUNC ('MONTH', CURRENT_DATE + INTERVAL '2 DAY')  > (DATE_TRUNC ('MONTH', CURRENT_DATE))
                    -- ��� vbIsSale
                 OR vbIsSale = TRUE
               --OR 1=1
                   ;


     -- !!!��������!!!
     /*IF inStartDate >= '01.02.2018' THEN
          return;
     END IF;*/

     /*IF inIsBefoHistoryCost = TRUE THEN
          return;
     END IF;*/

     -- !!!������!!!
     -- inIsBefoHistoryCost:= FALSE;
     -- !!!������!!!
     /*IF inIsSale = TRUE
     THEN
         inIsBefoHistoryCost:= FALSE;
     END IF;*/


     -- ���������
     RETURN QUERY
     WITH tmpUnit AS (/*SELECT 8411 AS UnitId, NULL AS isMain -- ����� �� �.����
                UNION SELECT 8413 AS UnitId, NULL AS isMain  -- �. ��.���
                UNION SELECT 8415 AS UnitId, NULL AS isMain  -- �. �������� ( ����������)
                UNION SELECT 8417 AS UnitId, NULL AS isMain  -- �. �������� (������)
                UNION SELECT 8421 AS UnitId, NULL AS isMain  -- �. ������
                UNION SELECT 8425 AS UnitId, NULL AS isMain  -- �. �������
                UNION SELECT 301309 AS UnitId, NULL AS isMain  -- ����� �� �.���������
                -- UNION SELECT 309599 AS UnitId, NULL AS isMain  -- ����� ��������� �.���������
                UNION SELECT 18341 AS UnitId, NULL AS isMain  -- �. ��������
                UNION SELECT 8419 AS UnitId, NULL AS isMain  -- �. ����
                UNION SELECT 8423 AS UnitId, NULL AS isMain  -- �. ������
                UNION SELECT 346093  AS UnitId, NULL AS isMain  -- ����� �� �.������
                -- UNION SELECT 346094  AS UnitId, NULL AS isMain  -- ����� ��������� �.������

                UNION SELECT tmp.UnitId, NULL AS isMain FROM lfSelect_Object_Unit_byGroup (8446) AS tmp -- ��� �������+���-��
                UNION SELECT tmp.UnitId, NULL AS isMain FROM lfSelect_Object_Unit_byGroup (8454) AS tmp -- ����� ������ � ���������

                UNION */SELECT tmp.UnitId, NULL AS isMain FROM lfSelect_Object_Unit_byGroup (8460 ) AS tmp -- 30000 - ��������������������
               )
       -- tmpUnit AS (SELECT tmp.UnitId, NULL AS isMain FROM lfSelect_Object_Unit_byGroup (8439) AS tmp) -- 31050 - ������� ������� �����
       -- tmpUnit AS (SELECT tmp.UnitId, NULL AS isMain FROM lfSelect_Object_Unit_byGroup (8459) AS tmp) -- 32022 - ����� ����������
     , tmpUnit_pack AS (SELECT 8451 AS UnitId, NULL AS isMain  -- ��� ��������
                  UNION SELECT 8450 AS UnitId, NULL AS isMain  -- ��� ��������
                       )
     , tmpUnit_branch AS (SELECT ObjectLink.ObjectId AS UnitId, NULL AS isMain
                               , Object_Branch.ObjectCode AS BranchCode
                               , Object_Branch.ValueData  AS BranchName
                          FROM ObjectLink
                               LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink.ChildObjectId
                          WHERE  ObjectLink.DescId = zc_ObjectLink_Unit_Branch()
                             AND ObjectLink.ChildObjectId > 0
                             AND ObjectLink.ChildObjectId <> zc_Branch_Basis()
                             AND (inGroupId < 0 -- -1:��� 0+4:�.����� 1:�.���� 2+3:��������� �������
                               OR inGroupId = 0
                               OR inGroupId = 4
                               OR (inGroupId = 1 AND ObjectLink.ChildObjectId IN (8379     -- ������ ����
                                                                              --, 3080683  -- ������ �����
                                                                                 )
                                  )
                               OR (inGroupId = 2 AND ObjectLink.ChildObjectId IN (--8373     -- ������ �������� (������)
                                                                                  8374     -- ������ ������
                                                                                 )
                                  )
                               OR (inGroupId = 3 AND ObjectLink.ChildObjectId NOT IN (8379     -- ������ ����
                                                                                  --, 3080683  -- ������ �����
                                                                                  --, 8373     -- ������ �������� (������)
                                                                                    , 8374     -- ������ ������
                                                                                     )
                                  ))
                             -- AND ObjectLink.ChildObjectId = 8379       -- ������ ����
                             -- AND ObjectLink.ChildObjectId = 3080683    -- ������ �����
                             -- AND ObjectLink.ChildObjectId = 8374       -- ������ ������
                        /*SELECT 301309 AS UnitId, NULL AS isMain  -- ����� �� �.���������
                    UNION SELECT 309599 AS UnitId, NULL AS isMain  -- ����� ��������� �.���������
                    UNION SELECT 346093  AS UnitId, NULL AS isMain  -- ����� �� �.������
                    UNION SELECT 346094  AS UnitId, NULL AS isMain  -- ����� ��������� �.������

                    UNION SELECT 8413 AS UnitId, NULL AS isMain  -- ����� �� �.������ ���
                    UNION SELECT 428366 AS UnitId, NULL AS isMain  -- ����� ��������� �.������ ���

                    UNION SELECT 8411 AS UnitId, NULL AS isMain  -- ����� �� �.����
                    UNION SELECT 428365 AS UnitId, NULL AS isMain  -- ����� ��������� �.����

                    UNION SELECT 8415 AS UnitId, NULL AS isMain  -- ����� �� �.�������� (����������)
                    UNION SELECT 428363 AS UnitId, NULL AS isMain  -- ����� ��������� �.�������� (����������)

                    UNION SELECT 8417 AS UnitId, NULL AS isMain  -- ����� �� �.�������� (������)
                    UNION SELECT 428364 AS UnitId, NULL AS isMain  -- ����� ��������� �.�������� (������)

                    UNION SELECT 8425 AS UnitId, NULL AS isMain  -- ����� �� �.�������
                    UNION SELECT 409007 AS UnitId, NULL AS isMain  -- ����� ��������� �.�������*/
                   )
     -- , tmp1 AS (SELECT DISTINCT HistoryCost.ContainerId FROM HistoryCost WHERE ('01.04.2016' BETWEEN StartDate AND EndDate) AND ABS (Price) = 1.1234 AND CalcSumm > 1000000)
     -- , tmp_err AS (SELECT DISTINCT MovementItemContainer.MovementId FROM tmp1 INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = tmp1.ContainerId AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate)

     , tmpContainer AS (SELECT 1250361 AS ContainerId
                       UNION
                        SELECT 1736845 AS ContainerId
                       )
     , tmpGoodsContainer AS (/*SELECT DISTINCT CLO.ObjectId AS GoodsId
                               FROM tmpContainer
                                    INNER JOIN ContainerLinkObject AS CLO
                                                                   ON CLO.ContainerId = tmpContainer.ContainerId
                                                                 AND CLO.DescId       = zc_ContainerLinkObject_Goods()*/
                             SELECT 5662  AS GoodsId
                            UNION
                             SELECT 3902   AS GoodsId
                            UNION
                             SELECT 607384   AS GoodsId
                            UNION
                             SELECT 1076606   AS GoodsId

--                             SELECT 8296254   AS GoodsId -- 94183
--                             SELECT 2365   AS GoodsId -- 135
                            )
     /*, tmpMovContainer AS (SELECT DISTINCT Movement.Id AS MovementId
                           FROM Movement
                                INNER JOIN MovementItem  ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.isErased   = FALSE
                                INNER JOIN tmpGoodsContainer  ON tmpGoodsContainer.GoodsId = MovementItem.ObjectId
                           WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                          )*/
     -- ���������
     SELECT tmp.MovementId
          , tmp.OperDate
          , (tmp.InvNumber || ' - ' || CASE WHEN tmp.BranchCode IN (1)     THEN tmp.BranchCode 
                                            WHEN tmp.BranchCode IN (2, 12) THEN tmp.BranchCode + 100
                                            ELSE COALESCE (tmp.BranchCode, 0) + 1000
                                       END :: TVarChar) :: TVarChar AS InvNumber
          , tmp.Code
          , tmp.ItemName
          , CASE WHEN tmp.BranchCode IN (1)     THEN tmp.BranchCode 
                 WHEN tmp.BranchCode IN (2, 12) THEN tmp.BranchCode + 100
                 ELSE tmp.BranchCode + 1000
            END :: Integer AS BranchCode
          , tmp.BranchName
     FROM (
     -- 1.3. To: ReturnIn
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          LEFT JOIN tmpUnit AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_ReturnIn())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND inIsBefoHistoryCost = FALSE
       AND tmpUnit_To.UnitId > 0
       AND 1=0

    UNION
     -- 2.1. Send + ProductionUnion + ProductionSeparate
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

          LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId
          LEFT JOIN tmpUnit AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId
          LEFT JOIN tmpUnit_pack AS tmpUnit_pack_from ON tmpUnit_pack_from.UnitId = MLO_From.ObjectId
          LEFT JOIN tmpUnit_pack As tmpUnit_pack_To ON tmpUnit_pack_To.UnitId = MLO_To.ObjectId

          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
       AND (tmpUnit_from.UnitId IS not NULL or  tmpUnit_To.UnitId IS not NULL)

    UNION
     -- 2.2. !!!Internal - SendOnPrice!!!
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId
          LEFT JOIN tmpUnit AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId

     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_SendOnPrice())
       AND Movement.StatusId = zc_Enum_Status_Complete()

       AND (tmpUnit_from.UnitId > 0 OR tmpUnit_To.UnitId > 0)

    UNION
     -- 3. !!!Inventory!!!
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , 0  :: Integer  AS BranchCode
          , '' :: TVarChar AS BranchName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId

     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.DescId IN (zc_Movement_Inventory())
       AND tmpUnit_from.UnitId > 0

    ) AS tmp
    -- INNER JOIN tmpMovContainer ON tmpMovContainer.MovementId = tmp.MovementId

    -- WHERE tmp.MovementId >= 2212722 OR tmp.Code = 'zc_Movement_Inventory'
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.11.14                                        *
*/
/*
create table dba._pgMovementReComlete
     MovementId integer
    ,OperDate date
    ,InvNumber TVarCharMedium
    ,Code  TVarCharMedium
    ,ItemName TVarCharMedium
 ,primary key (MovementId)
*/
/*
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , MovementDesc.ItemName
     FROM (SELECT MovementItemContainer.MovementId
           FROM Container
                INNER JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                               ON ContainerLO_ProfitLoss.ContainerId = Container.Id
                                              AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                              AND ContainerLO_ProfitLoss.ObjectId = 0
                INNER JOIN MovementItemContainer
                        ON MovementItemContainer.ContainerId = Container.Id
                       AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
           WHERE Container.ObjectId = zc_Enum_Account_100301() -- ������� �������� �������
           GROUP BY MovementItemContainer.MovementId
          ) AS tmp
          LEFT JOIN Movement ON Movement.Id = tmp.MovementId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
*/
-- ����
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.03.2019', inEndDate:= '31.03.2019', inIsSale:= TRUE, inIsBefoHistoryCost:= TRUE, inGroupId:= -1)
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.03.2019', inEndDate:= '31.03.2019', inIsSale:= TRUE, inIsBefoHistoryCost:= FALSE, inGroupId:= -1)
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.06.2019', inEndDate:= '30.06.2019', inIsSale:= TRUE, inIsBefoHistoryCost:= TRUE, inGroupId:= -1)
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.06.2023', inEndDate:= '31.06.2023', inIsSale:= TRUE, inIsBefoHistoryCost:= FALSE, inGroupId:= -1)
