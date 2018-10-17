with tmpRes as (
SELECT *
  , ROW_NUMBER() OVER (PARTITION BY PaidKindId, ContractId, PartnerId, JuridicalId ORDER BY StartDate ASC, ObjectId ASC) AS Ord
  , ROW_NUMBER() OVER (ORDER BY ObjectId ASC) AS Ord2
from (
SELECT ObjectDate_Start.ObjectId
, ObjectDate_Start.ValueData as StartDate
, ObjectDate_End.ValueData as EndDate
, coalesce (ObjectLink_ReportCollation_PaidKind.ChildObjectId , 0)AS PaidKindId
, coalesce (ObjectLink_ReportCollation_Contract.ChildObjectId, 0) AS ContractId
, coalesce (ObjectLink_ReportCollation_Partner.ChildObjectId, 0) AS PartnerId
, coalesce (ObjectLink_ReportCollation_Juridical.ChildObjectId, 0) as JuridicalId
                                       -- AND (ObjectLink_ReportCollation_Juridical.ChildObjectId = COALESCE (inJuridicalId,0) OR COALESCE (inJuridicalId,0)=0)
               FROM ObjectDate AS ObjectDate_Start
                  INNER JOIN ObjectDate AS ObjectDate_End 
                                        ON ObjectDate_End.ObjectId  = ObjectDate_Start.ObjectId
                                       AND ObjectDate_End.DescId    = zc_ObjectDate_ReportCollation_End()

                  INNER JOIN ObjectLink AS ObjectLink_ReportCollation_PaidKind
                                       ON ObjectLink_ReportCollation_PaidKind.ObjectId = ObjectDate_Start.ObjectId
                                      AND ObjectLink_ReportCollation_PaidKind.DescId = zc_ObjectLink_ReportCollation_PaidKind()
                  INNER JOIN ObjectLink AS ObjectLink_ReportCollation_Juridical
                                        ON ObjectLink_ReportCollation_Juridical.ObjectId = ObjectDate_Start.ObjectId
                                       AND ObjectLink_ReportCollation_Juridical.DescId = zc_ObjectLink_ReportCollation_Juridical()
                  INNER JOIN ObjectLink AS ObjectLink_ReportCollation_Partner
                                        ON ObjectLink_ReportCollation_Partner.ObjectId = ObjectDate_Start.ObjectId
                                       AND ObjectLink_ReportCollation_Partner.DescId = zc_ObjectLink_ReportCollation_Partner()
                  INNER JOIN ObjectLink AS ObjectLink_ReportCollation_Contract
                                        ON ObjectLink_ReportCollation_Contract.ObjectId = ObjectDate_Start.ObjectId
                                       AND ObjectLink_ReportCollation_Contract.DescId = zc_ObjectLink_ReportCollation_Contract()
              WHERE ObjectDate_Start.DescId = zc_ObjectDate_ReportCollation_Start()
) as tmp
)
-- update Object set ObjectCode = Ord from tmpRes where Object.Id = tmpRes.ObjectId

select tmpRes_old.StartDate , tmpRes_old.EndDate , tmpRes.StartDate, tmpRes.EndDate ,  tmpRes.Ord, tmpRes.Ord2,  * 
from tmpRes
inner join tmpRes as tmpRes_old on tmpRes_old.PaidKindId = tmpRes.PaidKindId
                              and tmpRes_old.ContractId = tmpRes.ContractId
                              and tmpRes_old.PartnerId  = tmpRes.PartnerId
                              and tmpRes_old.JuridicalId = tmpRes.JuridicalId
                              and tmpRes_old.Ord  = tmpRes.Ord - 1
where tmpRes_old.EndDate <> tmpRes.StartDate - INTERVAL '1 DAY'
-- and tmpRes_old.EndDate > tmpRes.StartDate
order by tmpRes.PaidKindId, tmpRes.ContractId, tmpRes.PartnerId, tmpRes.JuridicalId, tmpRes.Ord

