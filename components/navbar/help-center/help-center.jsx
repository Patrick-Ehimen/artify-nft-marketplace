import React from "react";
import Link from "next/link";

import Style from "./help-center.module.css";
import { helpCenter } from "../../../constants";

export default function HelpCenter() {
  return (
    <div className={Style.box}>
      {helpCenter.map((el, i) => (
        <div className={Style.helpCenter} key={i + 1}>
          <Link href={{ pathname: `${el.link}` }}>{el.name}</Link>
        </div>
      ))}
    </div>
  );
}
