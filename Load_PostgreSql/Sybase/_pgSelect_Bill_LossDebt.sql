-- Int - LossDebt
alter PROCEDURE "DBA"."_pgSelect_Bill_LossDebt" (in @inEndDate date)
result (ObjectId Integer, InfoMoneyCode integer, InfoMoneyId_PG integer, isSale smallint, Summa  TSumm, ClientId_pg Integer, ClientCode Integer, ClientName TVarCharMedium, ClientName_Dolg  TVarCharMedium, OKPO TVarCharMedium, isOKPO_Virtual smallint, minId Integer, maxId Integer)
begin
   //
  declare @saveRemains smallint;
   //
  declare local temporary table _tmpResult(
        UnitId Integer
      , Summa TSumm
      , InfoMoneyCode integer
      , isSale smallint
  ) on commit preserve rows;
   //
   //
   -- !!!!!!!!!!!!!
   set @saveRemains = zc_rvYes();
   -- set @saveRemains = zc_rvNo();
   -- !!!!!!!!!!!!!

   if @saveRemains = zc_rvNo()
   then
        -- !!! no calc - only restore !!!
        insert into _tmpResult (UnitId, Summa, InfoMoneyCode, isSale) select UnitId, Summa, InfoMoneyCode, isSale from dba._pgLossDebt;
   else

   //
   -- 1.1. 3229	���������� ����	30201	������ ����� + ������ �����
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 3229, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa, InfoMoneyCode       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , 30201 AS InfoMoneyCode -- ������ ����� + ������ �����
          , zc_rvYes() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   --
   -- 1.2. 3534	���������� ������	30501	������ ������ + ������ ������
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 3534, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa, InfoMoneyCode       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , 30501 AS InfoMoneyCode -- ������ ������ + ������ ������
          , zc_rvYes() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   -- 1.3. 6	���������� �������	30101	��������� + ������� ���������
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 6, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa, InfoMoneyCode       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , 30101 AS InfoMoneyCode -- ��������� + ������� ���������
          , zc_rvYes() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   //
   //
   -- 2.1. 9606	���������� ���������	20701	������ + ������ ������
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 9606, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa, InfoMoneyCode       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , 20701 AS InfoMoneyCode -- ������ + ������ ������
          , zc_rvNo() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   --
   -- 2.2. 3624	���������� �����. ���-��	20205	������ ��� + ������ ���
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 3624, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa, InfoMoneyCode       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , 20205 AS InfoMoneyCode -- ������ ��� + ������ ���
          , zc_rvNo() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   --
   -- 2.3. 3617	���������� ��������	20101	�������� � ������� + �������� � �������
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 3617, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa, InfoMoneyCode       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , 20101 AS InfoMoneyCode -- �������� � ������� + �������� � �������
          , zc_rvNo() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   --
   -- 2.4. 8306	���������� �������� ����	20101	�������� � ������� + �������� � �������
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 8306, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa, InfoMoneyCode       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , 20101 AS InfoMoneyCode -- �������� � ������� + �������� � �������
          , zc_rvNo() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   --
   -- 2.5. 5025	���������� ��� �������	10204	������ ����� + ������ �����
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 5025, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa, InfoMoneyCode       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , 10204 AS InfoMoneyCode -- ������ ����� + ������ �����
          , zc_rvNo() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   --
   -- 2.6. 3275	����������-������	10201	������ ����� + ������
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 3275, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa, InfoMoneyCode       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , 10201 AS InfoMoneyCode -- ������ ����� + ������
          , zc_rvNo() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   --
   -- 2.7. 3274	����������-����	10102	������ �����+�������
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 3274, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa, InfoMoneyCode       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , 10102 AS InfoMoneyCode -- ������ �����+�������
          , zc_rvNo() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   --
   -- 2.8. 3276	����������-����	10101	������ �����+����� ���
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 3276, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa, InfoMoneyCode       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , 10101 AS InfoMoneyCode -- ������ �����+����� ���
          , zc_rvNo() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   --
   -- 2.9. 9286	���������� �������	70402	����������� ������������� + �������
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 9286, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa, InfoMoneyCode       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , 70402 AS InfoMoneyCode -- ����������� ������������� + �������
          , zc_rvNo() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   --
   -- 2.10. 3775	���������� ����-�����	10204	������ ����� + ������ �����
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 3775, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId, Summa, InfoMoneyCode, isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , 10204 AS InfoMoneyCode -- ������ ����� + ������ �����
          , zc_rvNo() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;

    -- ����-��������� ***���.����
   delete from _tmpResult where UnitId in (select 4846 union select Id from dba.Unit where DolgByUnitID = 4846);
   //
   //
   -- !!! save !!!
   delete from dba._pgLossDebt;
   insert into dba._pgLossDebt (UnitId, Summa, InfoMoneyCode, isSale) select UnitId, Summa, InfoMoneyCode, isSale from _tmpResult where Summa <> 0;

   end if; -- !!!if @saveRemains = zc_rvNo()!!!

   //
   -- result
   select _tmpResult.UnitId as ObjectId
        -- , CASE WHEN _tmpResult.isSale = zc_rvYes() then @MovementId_Sale else @MovementId_Income end AS MovementId_pg
        , _tmpResult.InfoMoneyCode
        , _pgInfoMoney.Id3_Postgres AS InfoMoneyId_PG
        , _tmpResult.isSale
        , _tmpResult.Summa
        , _tmpResult.ClientId_pg
        , Unit.UnitCode as ClientCode
        , Unit.UnitName as ClientName
        , isnull (Unit_Dolg.UnitName, Unit.UnitName) as ClientName_Dolg
        , _tmpResult.OKPO
        , zf_isOKPO_Virtual_PG (_tmpResult.OKPO) as isOKPO_Virtual
        , _tmpResult.minId
        , _tmpResult.maxId
   from (select isnull (Unit_dolg.Id, Unit.Id) as UnitId
              , isnull (Unit.DolgByUnitID, Unit.Id) as DolgByUnitID
              , _tmpResult.InfoMoneyCode
              , _tmpResult.isSale
              , sum (_tmpResult.Summa) as Summa
              , min (Unit.Id) as minId
              , max (Unit.Id) as maxId
              , max (isnull (_pgPartner.PartnerId_pg, isnull (Unit.Id3_Postgres, 0))) as ClientId_pg
              , max (isnull (Information1.OKPO, isnull (Information2.OKPO, ''))) AS OKPO
         from _tmpResult
              left outer join dba.Unit on Unit.Id = _tmpResult.UnitId
              left outer join dba.Unit as Unit_dolg on Unit_dolg.Id = Unit.DolgByUnitID
                                                   and 1=0
              left outer join (select max (isnull(_pgPartner.PartnerId_pg,0)) as PartnerId_pg, OKPO, UnitId, Main from dba._pgPartner where trim(OKPO) <> '' and _pgPartner.PartnerId_pg <> 0 and UnitId <>0 and Main <> 0 group by OKPO, UnitId, Main
                              ) as _pgPartner on _pgPartner.UnitId = _tmpResult.UnitId
              left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                                   and Information1.OKPO <> ''
              left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id

         group by UnitId, DolgByUnitID, _tmpResult.InfoMoneyCode, _tmpResult.isSale -- , OKPO
         having sum (_tmpResult.Summa) <> 0
        ) as _tmpResult
        left outer join dba.Unit on Unit.Id = _tmpResult.UnitId
        left outer join dba.Unit as Unit_Dolg on Unit_Dolg.Id = _tmpResult.DolgByUnitID
        left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = _tmpResult.InfoMoneyCode
   order by isSale, isnull (Unit_Dolg.UnitName, Unit.UnitName), ClientName
   ;

end
go
//
-- select * from _pgLossDebt left join dba.Unit on Unit.Id = UnitId where UnitId in (select UnitId from _pgLossDebt group by UnitId having count(*)>1) order by Unit.UnitName
-- delete from _pgLossDebt where Summa = 0

-- select sum (summa) from dba._pgSelect_Bill_LossDebt ('2014-05-31') as a where isSale = zc_rvYes()
-- select * from dba._pgSelect_Bill_LossDebt ('2014-05-31') as a where ClientId_pg = 0 and isSale = zc_rvYes() order by ClientName
-- select * from dba._pgSelect_Bill_LossDebt ('2014-05-31') as a where isSale = zc_rvYes() order by ClientName
-- call dba._pgSelect_Bill_LossDebt ('2014-05-31') 