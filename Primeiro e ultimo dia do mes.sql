declare @dia date

set @dia=getdate()

select dateadd(day,(day(@dia)-1)*-1,@dia)PrimeiroDia


select eomonth(@dia)UltimoDia

