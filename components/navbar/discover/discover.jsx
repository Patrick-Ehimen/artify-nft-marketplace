import React from "react";
import Link from "next/link";

import Style from "./discover.module.css";
import { discover } from "../../../constants";

export default function Discover() {
  return (
    <div>
      {discover.map((el, i) => (
        <div key={i + 1} className={Style.discover}>
          <Link href={{ pathname: `${el.link}` }}>{el.name}</Link>
        </div>
      ))}
    </div>
  );
}
