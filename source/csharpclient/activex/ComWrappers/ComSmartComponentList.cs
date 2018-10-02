using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace TWSLib
{
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComSmartComponentList : IComList
    {
        private ComList<ComSmartComponent, KeyValuePair<int, KeyValuePair<string, char>>> scl;

        public ComSmartComponentList(Dictionary<int, KeyValuePair<string, char>> initData)
        {
            scl = new ComList<ComSmartComponent, KeyValuePair<int, KeyValuePair<string, char>>>(initData.ToList());
        }

        public object _NewEnum
        {
            get { return scl.GetEnumerator(); }
        }

        public object this[int index]
        {
            get { return scl[index]; }
        }

        public int Count
        {
            get { return scl.Count; }
        }

        public object Add()
        {
            var rval = new ComSmartComponent();

            scl.Add(rval);

            return rval;
        }
    }
}
