//+------------------------------------------------------------------+
//|                                         OrderStopPendingBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "OrderStopBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopPendingBase : public COrderStop
  {
public:
                     COrderStopPendingBase(void);
                    ~COrderStopPendingBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_ORDERSTOP_PENDING;}
   virtual void      Check(double&);
protected:
   virtual bool      ModifyStopLoss(const double);
   virtual bool      ModifyTakeProfit(const double);
   virtual bool      UpdateOrderStop(const double,const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopPendingBase::COrderStopPendingBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopPendingBase::~COrderStopPendingBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopPendingBase::Check(double &volume)
  {
   if(!CheckPointer(m_stop) || !Active())
      return;
   if(m_order.IsClosed() || m_order.IsSuspended())
     {
      bool delete_sl=false,delete_tp=false;
      if(m_stoploss_ticket>0 && !m_stoploss_closed)
         if(m_stop.DeleteStopOrder(m_stoploss_ticket))
           {
            m_stoploss_closed=true;
            delete_sl=DeleteStopLoss();
           }
      if(m_takeprofit_ticket>0 && !m_takeprofit_closed)
         if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
           {
            m_takeprofit_closed=true;
            delete_tp=DeleteTakeProfit();
           }
      if(delete_sl && delete_tp)
         DeleteEntry();
      return;
     }
   if(!m_stoploss_closed)
     {
      if(m_stop.CheckStopOrder(volume,m_stoploss_ticket))
         m_stoploss_closed=true;
     }
   if(!m_takeprofit_closed)
     {
      if(m_stop.CheckStopOrder(volume,m_takeprofit_ticket))
         m_takeprofit_closed=true;
     }
   if(m_stoploss_closed || m_takeprofit_closed)
     {
      if(m_stop.OCO())
        {
         if(m_stoploss_closed && !m_takeprofit_closed)
           {
            if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
               m_takeprofit_closed=true;
           }

         if(m_takeprofit_closed && !m_stoploss_closed)
           {
            if(m_stop.DeleteStopOrder(m_stoploss_ticket))
               m_stoploss_closed=true;
           }
        }
      if(m_stoploss_closed)
         DeleteStopLoss();
      if(m_takeprofit_closed)
         DeleteTakeProfit();
     }
   if((m_stoploss_closed && m_takeprofit_closed) || volume<=0)
     {
      DeleteStopLines();
      if(m_stop.Main())
         m_order.IsSuspended(true);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopPendingBase::ModifyStopLoss(const double stoploss)
  {
   if(m_stop.OrderModify(m_stoploss_ticket,stoploss))
      return MoveStopLoss(stoploss);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopPendingBase::ModifyTakeProfit(const double takeprofit)
  {
   if(m_stop.OrderModify(m_takeprofit_ticket,takeprofit))
      return MoveTakeProfit(takeprofit);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopPendingBase::UpdateOrderStop(const double stoploss,const double takeprofit)
  {
   bool modify_sl=true,modify_tp=true;   
   if(stoploss>0)
   {
      modify_sl=m_stop.MoveStopLoss(StopLossTicket(),stoploss);
      if (modify_sl)
         StopLoss(stoploss);
   }   
   if(takeprofit>0)
   {
      modify_tp=m_stop.MoveTakeProfit(TakeProfitTicket(),takeprofit);
      if (modify_tp)
         TakeProfit(takeprofit);
   }   
   return modify_sl && modify_tp;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Order\OrderStopPending.mqh"
#else
#include "..\..\MQL4\Order\OrderStopPending.mqh"
#endif
//+------------------------------------------------------------------+
