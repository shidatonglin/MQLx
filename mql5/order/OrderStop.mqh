//+------------------------------------------------------------------+
//|                                                    OrderStop.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrderStop : public JOrderStopBase
  {
public:
                     JOrderStop(void);
                    ~JOrderStop(void);
   virtual void      Check(double &volume);
protected:
   virtual bool      ModifyStops(const double stoploss,const double takeprofit);
   virtual bool      ModifyStopLoss(const double stoploss);
   virtual bool      ModifyTakeProfit(const double takeprofit);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStop::JOrderStop(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStop::~JOrderStop(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderStop::Check(double &volume)
  {
   if(m_stop==NULL) return;
   CheckInit();
   if(m_order.IsClosed())
     {
      bool delete_sl=false,delete_tp=false;
      if(m_stop.Pending() || m_stop.Broker())
        {
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
        }
      else
        {
         delete_sl=DeleteStopLoss();
         delete_tp=DeleteTakeProfit();
        }
      if(delete_sl && delete_tp)
         DeleteEntry();
      return;
     }
   if(CheckPointer(m_objsl)==POINTER_DYNAMIC && !m_stoploss_closed)
     {
      if(m_stop.Pending() || m_stop.Broker())
        {
         if(m_stop.CheckStopOrder(volume,m_stoploss_ticket))
            m_stoploss_closed=true;
        }
      else
        {
         if(m_stop.CheckStopLoss(m_order,GetPointer(this)))
           {
            m_stoploss_closed=true;
           }
        }
     }
   if(CheckPointer(m_objtp)==POINTER_DYNAMIC && !m_takeprofit_closed)
     {
      //Print("tp is already closed");
      if(m_stop.Pending() || m_stop.Broker())
        {
         if(m_stop.CheckStopOrder(volume,m_takeprofit_ticket))
            m_takeprofit_closed=true;
        }
      else
        {
         if(m_stop.CheckTakeProfit(m_order,GetPointer(this)))
            m_takeprofit_closed=true;
        }
     }
   if(m_stoploss_closed || m_takeprofit_closed)
     {
      Print("either sl or tp is closed");
      if(m_stop.OCO())
        {
         if(m_stoploss_closed && !m_takeprofit_closed)
           {
            if(m_stop.Pending() || m_stop.Broker())
              {
               if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
                  m_takeprofit_closed=true;
              }
            else m_takeprofit_closed=true;
           }

         if(m_takeprofit_closed && !m_stoploss_closed)
           {
            if(m_stop.Pending() || m_stop.Broker())
              {
               if(m_stop.DeleteStopOrder(m_stoploss_ticket))
                  m_stoploss_closed=true;
              }
            else m_stoploss_closed=true;
           }
        }
      if(m_stoploss_closed)
         DeleteStopLoss();
      if(m_takeprofit_closed)
         DeleteTakeProfit();
     }
   if(((m_stoploss_closed || m_objsl==NULL) && (m_takeprofit_closed || m_objtp==NULL)) || volume<=0)
     {
      DeleteStopLines();
      if(m_stop.Main())
      {
         m_order.IsClosed(true);
         //m_order.CloseStops();
      }   
     }
   CheckDeinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStop::ModifyStops(const double stoploss,const double takeprofit)
  {
   return ModifyStopLoss(stoploss) && ModifyTakeProfit(takeprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStop::ModifyStopLoss(const double stoploss)
  {
   bool modify=false;
   if(m_stop.Pending() || m_stop.Main())
      modify=m_stop.OrderModify(m_stoploss_ticket,stoploss);
   else modify=true;
   if(modify)
      MoveStopLoss(stoploss);
   return modify;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStop::ModifyTakeProfit(const double takeprofit)
  {
   bool modify=false;
   if(m_stop.Pending() || m_stop.Main())
      modify=m_stop.OrderModify(m_takeprofit_ticket,takeprofit);
   else modify=true;
   if(modify)
      MoveTakeProfit(takeprofit);
   return modify;
  }
//+------------------------------------------------------------------+
