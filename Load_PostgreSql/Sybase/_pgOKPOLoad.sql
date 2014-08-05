alter FUNCTION DBA.fInsert_pgPartner (in @ClientID integer,in @OKPO TVarCharLongLong,in @adr TVarCharLongLong, in @CodeIM TVarCharLongLong)
returns smallint
begin atomic
    declare @Main integer;

print '@OKPO';
print @OKPO;
print zf_isOKPO_Virtual_PG(@OKPO);


    if trim (@OKPO) = '' then raiserror 21000 'trim (@OKPO)'; end if;
    if zf_isOKPO_Virtual_PG(@OKPO) = zc_rvYes() then raiserror 21000 'zf_isOKPO_Virtual_PG'; end if;


    select max (Main) into @Main from dba._pgPartner where trim (okpo) = trim (@OKPO) and trim (AdrUnit) = trim (@adr) and @Main <> '';

    if isnull(@Main, 0) = 0 then
       select max (Main) into @Main from dba._pgPartner where trim (okpo) = trim (@OKPO) and Main <> '';
    end if;

    set @Main = isnull(@Main, 0) + 1;

    insert into dba._pgPartner (Main
                        , Name
                        , NameAll
                        , OKPO
                        , Adr
                        , UnitId
                        , UnitName
                        , AdrUnit
                        , CodeIM
                        , MoneyKindID

                        , NPP
                        , Inn
                        , NSvid
                        , PHone
                        , FioB
                        , Nalog5
                        , NameIM
                        , ContractName
                        , ContractNumber
                        , Date0
                        , Date1
                        , Date2
                        , ContractVid
                        , NumberSheet

                        )
    select @main, Unit_inf.UnitName, Unit_inf.UnitName, OKPO, AddressFirm, Unit.id, Unit.UnitName,  @adr, @CodeIM, zc_mkNal(), '', '', '', '', '', '', '', '', '', '', '', '', '', ''
    from dba.Unit
         left outer join dba.ClientInformation as Information on Information.ClientID = isnull(zf_ChangeIntToNull(Unit.InformationFromUnitId),Unit.Id)
         left outer join dba.Unit as Unit_inf on Unit_inf.ID = isnull(zf_ChangeIntToNull(Unit.InformationFromUnitId),Unit.Id)
    where Unit.Id = @ClientID;


    return(0);
end



update dba.ClientInformation
set ClientInformation.OKPO = tmp . okpoNew
from (

select isnull (Information1.ClientId, isnull (Information2.ClientId, 0)) AS ClientId,  isnull (Information1.OKPO, isnull (Information2.OKPO, '')) AS OKPO, a.okpo as okpoNew
, Unit.*
from (
select '2725117065' as okpo, '7568' as id
union select '2870311941' as okpo, '8691' as id
union select '2874614678' as okpo, '7601' as id
union select '2874614678' as okpo, '7100' as id
union select '2614918397' as okpo, '6856' as id
union select '2614918397' as okpo, '1571' as id
union select '34195448' as okpo, '7604' as id
union select '34195448' as okpo, '7606' as id
union select '34195448' as okpo, '7352' as id
union select '34195448' as okpo, '7605' as id
union select '2263807283' as okpo, '7563' as id
union select '2106702913' as okpo, '3499' as id
union select '2184300546' as okpo, '6760' as id
union select '2284009822' as okpo, '7688' as id
union select '2034607292' as okpo, '1665' as id
union select '3078417696' as okpo, '7860' as id
union select '3078417696' as okpo, '8883' as id
union select '' as okpo, '8509' as id
union select '3124213294' as okpo, '8069' as id
union select '' as okpo, '7358' as id
union select '2152819598' as okpo, '2798' as id
union select '2292700434' as okpo, '718' as id
union select '' as okpo, '4908' as id
union select '' as okpo, '4634' as id
union select '3173518575' as okpo, '7567' as id
union select '1953600900' as okpo, '8505' as id
union select '2226200434' as okpo, '8747' as id
union select '' as okpo, '3594' as id
union select '2646900669' as okpo, '9475' as id
union select '1747309381' as okpo, '7037' as id
union select '2280900468' as okpo, '1925' as id
union select '1840518125' as okpo, '7006' as id
union select '2647712066' as okpo, '' as id
union select '1626706811' as okpo, '7496' as id
union select '1641302607' as okpo, '2946' as id
union select '1920313627' as okpo, '6697' as id
union select '1930000607' as okpo, '6855' as id
union select '19313262' as okpo, '9049' as id
union select '1985117063' as okpo, '7366' as id
union select '2018400197' as okpo, '7575' as id
union select '2030813893' as okpo, '2691' as id
union select '2032902279' as okpo, '7365' as id
union select '2043321162' as okpo, '7851' as id
union select '2055600711' as okpo, '6854' as id
union select '2090908246' as okpo, '4924' as id
union select '2110814046' as okpo, '8398' as id
union select '2129600246' as okpo, '' as id
union select '2123309845' as okpo, '5305' as id
union select '2123309845' as okpo, '5305' as id
union select '2123309845' as okpo, '5310' as id
union select '2123309845' as okpo, '5309' as id
union select '2123309845' as okpo, '5307' as id
union select '2129600246' as okpo, '7077' as id
union select '2136016925' as okpo, '6732' as id
union select '2143000231' as okpo, '6757' as id
union select '2153503262' as okpo, '6762' as id
union select '2156114858' as okpo, '9170' as id
union select '2181200238' as okpo, '9055' as id
union select '2195400404' as okpo, '160' as id
union select '2216721968' as okpo, '9078' as id
union select '2216721968' as okpo, '9078' as id
union select '2221601408' as okpo, '8554' as id
union select '2238507992' as okpo, '7526' as id
union select '2258915161' as okpo, '6691' as id
union select '2259700436' as okpo, '6686' as id
union select '227561823' as okpo, '8529' as id
union select '2284802641' as okpo, '8346' as id
union select '2288406418' as okpo, '4916' as id
union select '2298400426' as okpo, '6667' as id
union select '2321616168' as okpo, '8510' as id
union select '2344212673' as okpo, '6863' as id
union select '2352914240' as okpo, '7018' as id
union select '2354321686' as okpo, '6701' as id
union select '2379104245' as okpo, '9349' as id
union select '2387700205' as okpo, '1637' as id
union select '2392324682' as okpo, '9093' as id
union select '2392324682' as okpo, '9094' as id
union select '3288617787' as okpo, '8528' as id
union select '2562500308' as okpo, '8531' as id
union select '2641115343' as okpo, '8530' as id
union select '2275618623' as okpo, '' as id
union select '2586501870' as okpo, '8532' as id
union select '2221601408' as okpo, '' as id
union select '2885800270' as okpo, '9165' as id
union select '2392513434' as okpo, '6661' as id
union select '2393600146' as okpo, '6862' as id
union select '2409900371' as okpo, '7090' as id
union select '2410500422' as okpo, '4912' as id
union select '2439112709' as okpo, '5338' as id
union select '2443500240' as okpo, '6898' as id
union select '2453320720' as okpo, '9088' as id
union select '2456113040' as okpo, '3593' as id
union select '2473911874' as okpo, '7689' as id
union select '2492317859' as okpo, '7599' as id
union select '2516608761' as okpo, '4917' as id
union select '25521415' as okpo, '6741' as id
union select '2561720875' as okpo, '7779' as id
union select '2571712427' as okpo, '7995' as id
union select '2571712427' as okpo, '8024' as id
union select '2571712427' as okpo, '7997' as id
union select '2571712427' as okpo, '7996' as id
union select '2571712427' as okpo, '7870' as id
union select '2574500375' as okpo, '7327' as id
union select '2593911790' as okpo, '6749' as id
union select '26003400151' as okpo, '' as id
union select '26003400151' as okpo, '8574' as id
union select '26003400151' as okpo, '' as id
union select '26003400151' as okpo, '8574' as id
union select '26005000622' as okpo, '6671' as id
union select '2606613162' as okpo, '6684' as id
union select '2606613162' as okpo, '6679' as id
union select '2608614508' as okpo, '9092' as id
union select '2608614508' as okpo, '9091' as id
union select '2614000589' as okpo, '7924' as id
union select '2634317301' as okpo, '8057' as id
union select '2635622597' as okpo, '9410' as id
union select '2635622597' as okpo, '9409' as id
union select '2635622597' as okpo, '9080' as id
union select '2635622597' as okpo, '9081' as id
union select '2677516544' as okpo, '9082' as id
union select '2639300450' as okpo, '2863' as id
union select '2640219959' as okpo, '8066' as id
union select '2656718356' as okpo, '7038' as id
union select '2656718356' as okpo, '7039' as id
union select '2665815987' as okpo, '9101' as id
union select '2665902082' as okpo, '6682' as id
union select '2671715508' as okpo, '2391' as id
union select '2749007956' as okpo, '3544' as id
union select '2754417664' as okpo, '9095' as id
union select '2754417664' as okpo, '9096' as id
union select '2754810045' as okpo, '9075' as id
union select '2784322536' as okpo, '6811' as id
union select '2823103482' as okpo, '8736' as id
union select '2832614823' as okpo, '7855' as id
union select '2851514580' as okpo, '6659' as id
union select '2868604398' as okpo, '6845' as id
union select '2870311941' as okpo, '6698' as id
union select '2883606597' as okpo, '3879' as id
union select '2898304987' as okpo, '9099' as id
union select '2904012959' as okpo, '2034' as id
union select '2904919498' as okpo, '8050' as id
union select '2931312504' as okpo, '9467' as id
union select '2932503754' as okpo, '7555' as id
union select '2938115775' as okpo, '6931' as id
union select '2946721718' as okpo, '7852' as id
union select '2947203966' as okpo, '8338' as id
union select '2992915094' as okpo, '1676' as id
union select '3027905772' as okpo, '9159' as id
union select '3027905772' as okpo, '9158' as id
union select '3032513343' as okpo, '7949' as id
union select '3032513343' as okpo, '7950' as id
union select '3048921621' as okpo, '7042' as id
union select '3049316921' as okpo, '9085' as id
union select '3053807463' as okpo, '7041' as id
union select '3053807463' as okpo, '7040' as id
union select '3093419621' as okpo, '5129' as id
union select '3099309370' as okpo, '7362' as id
union select '3100620589' as okpo, '8297' as id
union select '3112404286' as okpo, '9050' as id
union select '3123203875' as okpo, '7107' as id
union select '3140512747' as okpo, '8320' as id
union select '3151713503' as okpo, '9285' as id
union select '3159909838' as okpo, '6902' as id
union select '3171319277' as okpo, '2754' as id
union select '3182521301' as okpo, '7118' as id
union select '3204909056' as okpo, '2083' as id
union select '3215103677' as okpo, '7766' as id
union select '32685442' as okpo, '6660' as id
union select '3270416890' as okpo, '8540' as id
union select '3369006922' as okpo, '8730' as id
union select '36095364' as okpo, '7053' as id
union select '36095364' as okpo, '' as id
union select '36840304' as okpo, '6813' as id
union select '36840304' as okpo, '6814' as id
union select '37989206' as okpo, '9353' as id
union select '38114074' as okpo, '7048' as id
) as a
left join unit on Unit.Id = a.Id
left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
           and Information1.OKPO <> ''
left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id

where trim (a.okpo) <> ''  and trim (a.id) <> ''
and okpoNew <> okpo
-- and ClientId <>0
) as tmp
where tmp . ClientId = ClientInformation.ClientId