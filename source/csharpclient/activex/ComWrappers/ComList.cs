/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace TWSLib
{
    public class ComList<ComT, T> : ComWrapper<List<T>>, IList<ComWrapper<T>>
        where T :  new()
        where ComT : new()
    {
        public ComList(List<T> data) { this.data = data; }

        public int IndexOf(ComWrapper<T> item)
        {
            return data.IndexOf(ChangeType(item));
        }

        static ComWrapper<T> ChangeType(T value)
        {
            return (new ComT() as ComWrapper<T>).ConvertFrom(value);
        }

        static T ChangeType(ComWrapper<T> value)
        {
            return (value as ComWrapper<T>).ConvertTo();
        }

        public void Insert(int index, ComWrapper<T> item)
        {
            data.Insert(index, ChangeType(item));
        }

        public void RemoveAt(int index)
        {
            data.RemoveAt(index);
        }

        public ComWrapper<T> this[int index]
        {
            get
            {
                return ChangeType(data[index]);
            }
            set
            {
                data[index] = ChangeType(value);
            }
        }

        public void Add(ComWrapper<T> item)
        {
            data.Add(ChangeType(item));
        }

        public void Clear()
        {
            data.Clear();
        }

        public bool Contains(ComWrapper<T> item)
        {
            return data.Contains(ChangeType(item));
        }

        public void CopyTo(ComWrapper<T>[] array, int arrayIndex)
        {
            throw new NotImplementedException();
        }

        public int Count
        {
            get { return data.Count; }
        }

        public bool IsReadOnly
        {
            get { return false; }
        }

        public bool Remove(ComWrapper<T> item)
        {
            return data.Remove(ChangeType(item));
        }

        public IEnumerator<ComWrapper<T>> GetEnumerator()
        {
            return data.Select(x => ChangeType(x)).GetEnumerator();
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return data.GetEnumerator();
        }
    }
}
