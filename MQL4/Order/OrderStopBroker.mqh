//+------------------------------------------------------------------+
//|                                              OrderStopBroker.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopBroker : public COrderStopBrokerBase
  {
public:
                     COrderStopBroker(void);
                    ~COrderStopBroker(void);
   virtual void      Check(double &);
protected:
   virtual bool      ModifyStops(const double,const double);
   virtual bool      ModifyStopLoss(const double);
   virtual bool      ModifyTakeProfit(const double);
   virtual bool      UpdateOrderStop(const double,const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBroker::COrderStopBroker(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBroker::~COrderStopBroker(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::UpdateOrderStop(const double stoploss,const double takeprofit)
  {
   bool modify_sl=false,modify_tp=false;
   if(stoploss>0)
      modify_sl=m_stop.MoveStopLoss(m_order.Ticket(),stoploss);
   if(takeprofit>0)
      modify_tp=m_stop.MoveTakeProfit(m_order.Ticket(),takeprofit);
   return modify_tp||modify_sl;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBroker::Check(double &volume)
  {
   if(!CheckPointer(m_stop) || !Active())
      return;
   if(m_order.IsClosed() || m_order.IsSuspended())
     {
      bool delete_sl=false,delete_tp=false;
      delete_sl=DeleteStopLoss();
      delete_tp=DeleteTakeProfit();
      if(delete_sl && delete_tp)
         DeleteEntry();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::ModifyStopLoss(const double stoploss)
  {
   bool modify=m_stop.MoveStopLoss(m_order.Ticket(),stoploss);
   if(modify)
      MoveStopLoss(stoploss);
   return modify;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::ModifyTakeProfit(const double takeprofit)
  {
   bool modify=m_stop.MoveTakeProfit(m_order.Ticket(),takeprofit);
   if(modify)
      MoveTakeProfit(takeprofit);
   return modify;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::ModifyStops(const double stoploss,const double takeprofit)
  {
   bool modify=m_stop.Move(m_order.Ticket(),stoploss,takeprofit);
   if(modify)
   {
      MoveStopLoss(stoploss);
      MoveTakeProfit(takeprofit);
   }   
   return modify;
  }
//+------------------------------------------------------------------+
