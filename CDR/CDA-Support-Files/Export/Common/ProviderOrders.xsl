<!-- This file contains templates regrading CDAHeader, Author, CreationTime-->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<!-- 门急诊病历医嘱模板-->
	<xsl:template match="Orders1" mode="PO1">
		<xsl:comment>门急诊病例医嘱</xsl:comment>
		<component>
			<section>
				<code code="46209-3" codeSystem="2.16.840.1.113883.6.1" displayName="Provider
Orders" codeSystemName="LOINC"/>
				<text/>
				<entry>
					<organizer classCode="CLUSTER" moodCode="EVN">
						<statusCode/>
						<component>
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.289.00" displayName="医嘱项目类型" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
								<value xsi:type="CD" code="01" displayName="药品类医嘱" codeSystem="2.16.156.10011.2.3.1.268" codeSystemName="医嘱项目类型代码表"/>
							</observation>
						</component>
						<component>
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.288.00" displayName="医嘱项目内容" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
								<effectiveTime>
									<xsl:comment>医嘱计划开始日期时间</xsl:comment>
									<low value="{StartDateTime}"/>
									<!--StartDateTime>
										<xsl:value-of select="StartDateTime"/>
									</StartDateTime-->
									<xsl:comment>医嘱计划结束日期时间</xsl:comment>
									<high value="{EndDateTime}"/>
									<!--EndDateTime>
										<xsl:value-of select="EndDateTime"/>
									</EndDateTime-->
								</effectiveTime>
								<xsl:comment>医嘱计划信息</xsl:comment>
								<value xsi:type="ST">
									<xsl:value-of select="Description"/>
								</value>
								<xsl:comment>执行者</xsl:comment>
								<performer>
									<xsl:comment>医嘱执行日期时间：DE06.00.222.00</xsl:comment>
									<time value="{Performer/PerformerTime}"/>
									<assignedEntity>
										<id root="2.16.156.10011.1.4"/>
										<xsl:comment>角色</xsl:comment>
										<code displayName="{Performer/Role}"/>
										<xsl:comment>医嘱执行者签名：DE02.01.039.00</xsl:comment>
										<assignedPerson>
											<name>
												<xsl:value-of select="Performer/AssignedPerson"/>
											</name>
										</assignedPerson>
										<xsl:comment>医嘱执行科室：DE08.10.026.00</xsl:comment>
										<representedOrganization>
											<name>
												<xsl:value-of select="Performer/OrderCategory"/>
											</name>
										</representedOrganization>
									</assignedEntity>
								</performer>
								<xsl:comment>作者：医嘱开立者</xsl:comment>
								<author>
									<!--医嘱开立日期时间：DE06.00.220.00-->
									<xsl:comment>医嘱开立日期时间：DE06.00.220.00</xsl:comment>
									<time value="{Author/CreationTime}"/>
									<assignedAuthor>
										<id root="2.16.156.10011.1.4"/>
										<!--角色-->
										<xsl:comment>角色</xsl:comment>
										<code displayName="{Author/Role}"/>
										<!--医嘱开立者签名：DE02.01.039.00-->
										<xsl:comment>医嘱开立者签名：DE02.01.039.00</xsl:comment>
										<assignedPerson>
											<name>
												<xsl:value-of select="Author/Creator"/>
											</name>
										</assignedPerson>
										<!--医嘱开立科室：DE08.10.026.00-->
										<xsl:comment>医嘱开立科室：DE08.10.026.00</xsl:comment>
										<representedOrganization>
											<name>
												<xsl:value-of select="Author/OrderCategory"/>
											</name>
										</representedOrganization>
									</assignedAuthor>
								</author>
								<xsl:comment>医嘱审核</xsl:comment>
								<participant typeCode="ATND">
									<!--医嘱审核日期时间：DE09.00.088.00-->
									<xsl:comment>医嘱审核日期时间：DE09.00.088.00</xsl:comment>
									<time value="{Auditing/AuditingTime}"/>
									<participantRole classCode="ASSIGNED">
										<id root="2.16.156.10011.1.4"/>
										<!--角色-->
										<xsl:comment>角色</xsl:comment>
										<code displayName="{Auditing/Role}"/>
										<!--医嘱审核人签名：DE02.01.039.00-->
										<xsl:comment>医嘱审核人签名：DE02.01.039.000</xsl:comment>
										<playingEntity classCode="PSN" determinerCode="INSTANCE">
											<name>
												<xsl:value-of select="Auditing/Auditor"/>
											</name>
										</playingEntity>
									</participantRole>
								</participant>
								<xsl:comment>医嘱取消</xsl:comment>
								<participant typeCode="ATND">
									<!--医嘱取消日期时间：DE06.00.234.00-->
									<xsl:comment>医嘱取消日期时间：DE06.00.234.00</xsl:comment>
									<time value="{Abrogate/AbrogateTime}"/>
									<participantRole classCode="ASSIGNED">
										<id root="2.16.156.10011.1.4"/>
										<!--角色-->
										<xsl:comment>角色</xsl:comment>
										<code displayName="{Abrogate/Role}"/>
										<!--取消医嘱者签名：DE02.01.039.00-->
										<xsl:comment>取消医嘱者签名：DE02.01.039.00</xsl:comment>
										<playingEntity classCode="PSN" determinerCode="INSTANCE">
											<name>
												<xsl:value-of select="Abrogate/Name"/>
											</name>
										</playingEntity>
									</participantRole>
								</participant>
								<xsl:comment>医嘱备注信息</xsl:comment>
								<entryRelationship typeCode="COMP">
									<observation classCode="OBS" moodCode="EVN">
										<code code="DE06.00.179.00" displayName="{OrdersNote/Name}" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
										<value xsi:type="ST">
											<xsl:value-of select="OrdersNote/Note"/>
										</value>
									</observation>
								</entryRelationship>
								<xsl:comment>医嘱执行状态</xsl:comment>
								<entryRelationship typeCode="COMP">
									<observation classCode="OBS" moodCode="EVN">
										<code code="DE06.00.290.00" displayName="{ExecutionStatus/Name}" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
										<value xsi:type="ST">
											<xsl:value-of select="ExecutionStatus/Status"/>
										</value>
									</observation>
								</entryRelationship>
							</observation>
						</component>
					</organizer>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!--急诊留观病历医嘱模板-->
	<xsl:template match="Orders1" mode="PO2">
		<xsl:comment>急诊留观病历医嘱</xsl:comment>
		<component>
			<section>
				<code code="46209-3" codeSystem="2.16.840.1.113883.6.1" displayName="Provider
Orders" codeSystemName="LOINC"/>
				<text/>
				<entry>
					<organizer classCode="CLUSTER" moodCode="EVN">
						<statusCode/>
						<component>
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.289.00" displayName="医嘱项目类型" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
								<value xsi:type="CD" code="01" displayName="药品类医嘱" codeSystem="2.16.156.10011.2.3.1.268" codeSystemName="医嘱项目类型代码表"/>
							</observation>
						</component>
						<component>
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.288.00" displayName="医嘱项目内容" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
								<effectiveTime>
									<xsl:comment>医嘱计划开始日期时间</xsl:comment>
									<low value="{StartDateTime}"/>
									<xsl:comment>医嘱计划结束日期时间</xsl:comment>
									<high value="{EndDateTime}"/>
								</effectiveTime>
								<xsl:comment>医嘱计划信息</xsl:comment>
								<value xsi:type="ST">
									<xsl:value-of select="Description"/>
								</value>
								<xsl:comment>执行者</xsl:comment>
								<performer>
									<xsl:comment>医嘱执行日期时间：DE06.00.222.00</xsl:comment>
									<time value="{Performer/PerformerTime}"/>
									<assignedEntity>
										<id root="2.16.156.10011.1.4" extension="医务人员编号"/>
										<code/>
										<xsl:comment>医嘱执行者签名：DE02.01.039.00</xsl:comment>
										<assignedPerson>
											<name>
												<xsl:value-of select="Performer/AssignedPerson"/>
											</name>
										</assignedPerson>
										<xsl:comment>医嘱执行科室：DE08.10.026.00</xsl:comment>
										<representedOrganization>
											<name>
												<xsl:value-of select="Performer/OrderCategory"/>
											</name>
										</representedOrganization>
									</assignedEntity>
								</performer>
								<xsl:comment>作者：医嘱开立者</xsl:comment>
								<author>
									<!--医嘱开立日期时间：DE06.00.220.00-->
									<xsl:comment>医嘱开立日期时间：DE06.00.220.00</xsl:comment>
									<time value="{Author/CreationTime}"/>
									<assignedAuthor>
										<id root="2.16.156.10011.1.4" extension="医务人员编号"/>
										<!--医嘱开立者签名：DE02.01.039.00-->
										<xsl:comment>医嘱开立者签名：DE02.01.039.00</xsl:comment>
										<assignedPerson>
											<name>
												<xsl:value-of select="Author/Creator"/>
											</name>
										</assignedPerson>
										<!--医嘱开立科室：DE08.10.026.00-->
										<xsl:comment>医嘱开立科室：DE08.10.026.00</xsl:comment>
										<representedOrganization>
											<name>
												<xsl:value-of select="Author/OrderCategory"/>
											</name>
										</representedOrganization>
									</assignedAuthor>
								</author>
								<xsl:comment>医嘱审核</xsl:comment>
								<participant typeCode="ATND">
									<!--医嘱审核日期时间：DE09.00.088.00-->
									<xsl:comment>医嘱审核日期时间：DE09.00.088.00</xsl:comment>
									<time value="{Auditing/AuditingTime}"/>
									<participantRole classCode="ASSIGNED">
										<id root="2.16.156.10011.1.4" extension="xxx"/>
										<!--角色-->
										<xsl:comment>角色</xsl:comment>
										<code displayName="{Auditing/Role}"/>
										<!--医嘱审核人签名：DE02.01.039.00-->
										<xsl:comment>医嘱审核人签名：DE02.01.039.00</xsl:comment>
										<playingEntity classCode="PSN" determinerCode="INSTANCE">
											<name>
												<xsl:value-of select="Auditing/Auditor"/>
											</name>
										</playingEntity>
									</participantRole>
								</participant>
								<xsl:comment>医嘱取消</xsl:comment>
								<participant typeCode="ATND">
									<!--医嘱取消日期时间：DE06.00.234.00-->
									<time value="{Abrogate/AbrogateTime}"/>
									<participantRole classCode="ASSIGNED">
										<id root="2.16.156.10011.1.4" extension="xxx"/>
										<!--角色-->
										<code displayName="{Abrogate/Role}"/>
										<!--取消医嘱者签名：DE02.01.039.00-->
										<playingEntity classCode="PSN" determinerCode="INSTANCE">
											<name>
												<xsl:value-of select="Abrogate/Name"/>
											</name>
										</playingEntity>
									</participantRole>
								</participant>
								<xsl:comment>医嘱备注信息</xsl:comment>
								<entryRelationship typeCode="COMP">
									<observation classCode="OBS" moodCode="EVN">
										<code code="DE06.00.179.00" displayName="{OrdersNote/Name}" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
										<value xsi:type="ST">
											<xsl:value-of select="OrdersNote/Note"/>
										</value>
									</observation>
								</entryRelationship>
								<xsl:comment>医嘱执行状态</xsl:comment>
								<entryRelationship typeCode="COMP">
									<observation classCode="OBS" moodCode="EVN">
										<code code="DE06.00.290.00" displayName="{ExecutionStatus/Name}" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
										<value xsi:type="ST">
											<xsl:value-of select="ExecutionStatus/Status"/>
										</value>
									</observation>
								</entryRelationship>
							</observation>
						</component>
					</organizer>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!-- 24小时内入出院记录医嘱模板 -->
	<xsl:template match="Orders1" mode="PO3">
		<xsl:comment>24小时内入出院记录医嘱</xsl:comment>
		<component>
			<section>
				<code code="46209-3" displayName="PROVIDER ORDERS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<!--出院医嘱条目-->
				<entry>
					<observation classCode="OBS" moodCode="RQO">
						<code code="DE06.00.287.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院医嘱"/>
						<!--出院医嘱开立日期时间-->
						<effectiveTime value="{Author/CreationTime}"/>
						<value xsi:type="ST">
							<xsl:value-of select="Description"/>
						</value>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!-- 住院病程：日常病程 、上级医师查房医嘱模板 -->
	<xsl:template match="Orders1" mode="PO4">
		<xsl:comment>住院病程：日常病程 、上级医师查房医嘱</xsl:comment>
		<component>
			<section>
				<code code="46209-3" codeSystem="2.16.840.1.113883.6.1" displayName="Provider Orders" codeSystemName="LOINC"/>
				<title>住院医嘱</title>
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.287.00" displayName="医嘱内容" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目"/>
						<value xsi:type="ST">
							<xsl:value-of select="Description"/>
						</value>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!-- 住院病程:出院医嘱模板 -->
	<xsl:template match="Orders1" mode="PO5">
		<xsl:comment>住院病程:出院医嘱</xsl:comment>
		<component>
			<section>
				<code code="46209-3" codeSystem="2.16.840.1.113883.6.1" displayName="Provider
Orders" codeSystemName="LOINC"/>
				<text/>
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE08.50.047.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="{ChineseMedicine/Name}"/>
						<value xsi:type="ST">
							<xsl:value-of select="ChineseMedicine/Description"/>
						</value>
					</observation>
				</entry>
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.136.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="{UsageMethod/Name}"/>
						<value xsi:type="ST">
							<xsl:value-of select="UsageMethod/Description"/>
						</value>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!-- 住院医嘱模板-->
	<xsl:template match="Orders1" mode="PO6">
		<xsl:comment>住院医嘱</xsl:comment>
		<component>
			<section>
				<!--N:!!!-->
				<code code="46209-3" codeSystem="2.16.840.1.113883.6.1" displayName="Provider Orders" codeSystemName="LOINC"/>
				<text/>
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.286.00" displayName="医嘱类别" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="CD" code="xxx" displayName="xxx" codeSystem="2.16.156.10011.2.3.2.58" codeSystemName="医嘱类别代码表"/>
					</observation>
				</entry>
				<entry>
					<organizer classCode="CLUSTER" moodCode="EVN">
						<statusCode/>
						<component>
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.289.00" displayName="医嘱项目类型" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
								<value xsi:type="CD" code="xxx" displayName="xxx" codeSystem="2.16.156.10011.2.3.1.268" codeSystemName="医嘱项目类型代码表"/>
							</observation>
						</component>
						<component>
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.288.00" displayName="医嘱项目内容" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
								<effectiveTime>
									<xsl:comment>医嘱计划开始日期时间</xsl:comment>
									<low value="StartDateTime"/>
									<xsl:comment>医嘱计划结束日期时间</xsl:comment>
									<high value="EndDateTime"/>
								</effectiveTime>
								<xsl:comment>医嘱计划信息</xsl:comment>
								<value xsi:type="ST">
									<xsl:value-of select="Description"/>
								</value>
								<xsl:comment>作者：医嘱开立者</xsl:comment>
								<author>
									<!--医嘱开立日期时间：DE06.00.220.00-->
									<time value="{Author/CreationTime}"/>
									<assignedAuthor>
										<id root="2.16.156.10011.1.4" extension="xxx"/>
										<code displayName="{Author/Role}"/>
										<!--医嘱开立者签名：DE02.01.039.00-->
										<assignedPerson>
											<name>
												<xsl:value-of select="Author/Creator"/>
											</name>
										</assignedPerson>
										<!--医嘱开立科室：DE08.10.026.00-->
										<representedOrganization>
											<name>
												<xsl:value-of select="Author/OrderCategory"/>
											</name>
										</representedOrganization>
									</assignedAuthor>
								</author>
								<xsl:comment>医嘱审核</xsl:comment>
								<participant typeCode="ATND">
									<!--医嘱审核日期时间：DE09.00.088.00-->
									<time value="{Auditing/AuditingTime}"/>
									<participantRole classCode="ASSIGNED">
										<id root="2.16.156.10011.1.4" extension="xxx"/>
										<!--角色-->
										<code displayName="{Auditing/Role}"/>
										<!--医嘱审核人签名：DE02.01.039.00-->
										<playingEntity classCode="PSN" determinerCode="INSTANCE">
											<name>
												<xsl:value-of select="Auditing/Auditor"/>
											</name>
										</playingEntity>
									</participantRole>
								</participant>
								<xsl:comment>医嘱核对</xsl:comment>
								<participant typeCode="ATND">
									<!--医嘱核对日期时间：DE06.00.205.00-->
									<time value="{Check/CheckTime}"/>
									<participantRole classCode="ASSIGNED">
										<id root="2.16.156.10011.1.4" extension="xxx"/>
										<!--角色-->
										<code displayName="{Check/Role}"/>
										<!--医嘱核对护士签名：DE02.01.039.00-->
										<playingEntity classCode="PSN" determinerCode="INSTANCE">
											<name>
											<xsl:value-of select="Check/Name"/>
											</name>
										</playingEntity>
									</participantRole>
								</participant>
								<!--医嘱停止-->
								<participant typeCode="ATND">
									<!--医嘱停止日期时间：DE06.00.218.00-->
									<time value="{OrdersStop/StopTime}"/>
									<participantRole classCode="ASSIGNED">
										<id root="2.16.156.10011.1.4" extension="xxx"/>
										<!--角色-->
										<code displayName="{OrdersStop/Role}"/>
										<!--停止医嘱者签名：DE02.01.039.00-->
										<playingEntity classCode="PSN" determinerCode="INSTANCE">
											<name>
											<xsl:value-of select="OrdersStop/Name"/>
											</name>
										</playingEntity>
									</participantRole>
								</participant>
								<xsl:comment>医嘱取消</xsl:comment>
								<participant typeCode="ATND">
									<!--医嘱取消日期时间：DE06.00.234.00-->
									<time value="{Abrogate/AbrogateTime}"/>
									<participantRole classCode="ASSIGNED">
										<id root="2.16.156.10011.1.4" extension="xxx"/>
										<!--角色-->
										<code displayName="{Abrogate/Role}"/>
										<!--取消医嘱者签名：DE02.01.039.00-->
										<playingEntity classCode="PSN" determinerCode="INSTANCE">
											<name>
												<xsl:value-of select="Abrogate/Name"/>
											</name>
										</playingEntity>
									</participantRole>
								</participant>
								<xsl:comment>医嘱备注信息</xsl:comment>
								<entryRelationship typeCode="COMP">
									<observation classCode="OBS" moodCode="EVN">
										<code code="DE06.00.179.00" displayName="{OrdersNote/Name}" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
										<value xsi:type="ST">
											<xsl:value-of select="OrdersNote/Note"/>
										</value>
									</observation>
								</entryRelationship>
								<xsl:comment>医嘱执行状态</xsl:comment>
								<entryRelationship typeCode="COMP">
									<observation classCode="OBS" moodCode="EVN">
										<code code="DE06.00.290.00" displayName="{ExecutionStatus/Name}" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
										<value xsi:type="ST">
											<xsl:value-of select="ExecutionStatus/Status"/>
										</value>
										<!--执行者-->
										<performer>
											<!--医嘱执行日期时间：DE06.00.222.00-->
											<time value="{Performer/PerformerTime}"/>
											<assignedEntity>
												<id root="2.16.156.10011.1.4" extension="xxx"/>
												<code displayName="{Performer/Role}"/>
												<!--医嘱执行者签名：DE02.01.039.00-->
												<assignedPerson>
													<name>
													<xsl:value-of select="Performer/AssignedPerson"/>
													</name>
												</assignedPerson>
												<!--医嘱执行科室：DE08.10.026.00-->
												<representedOrganization>
													<name>
													<xsl:value-of select="Performer/OrderCategory"/>
													</name>
												</representedOrganization>
											</assignedEntity>
										</performer>
									</observation>
								</entryRelationship>
								<!--电子申请单编号：例如检查检验申请单编号？？？-->
								<entryRelationship typeCode="COMP">
									<observation classCode="OBS" moodCode="EVN">
										<code code="{ApplicationNumber/Code}" displayName="{ApplicationNumber/Name}" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
										<value xsi:type="{ApplicationNumber/Type}">
										<xsl:value-of select="ApplicationNumber/Description"/>
										</value>
									</observation>
								</entryRelationship>
								<!--处方药品组号：例如如果是用药医嘱的话指向处方单号？？？-->
								<entryRelationship typeCode="COMP">
									<observation classCode="OBS" moodCode="EVN">
										<code code="{PrescriptionNumber/Code}" displayName="{PrescriptionNumber/Name}" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
										<value xsi:type="{PrescriptionNumber/Type}">
										<xsl:value-of select="PrescriptionNumber/Description"/>
										</value>
									</observation>
								</entryRelationship>
							</observation>
						</component>
					</organizer>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!-- 出院小结医嘱模板-->
	<xsl:template match="Orders1" mode="PO7">
		<xsl:comment>出院小结医嘱</xsl:comment>
		<component>
			<section>
				<code code="46209-3" codeSystem="2.16.840.1.113883.6.1" displayName="Provider Orders" codeSystemName="LOINC"/>
				<text/>
				<xsl:comment>HDSD00.16.049 DE08.50.047.00 中药煎煮方法 条目</xsl:comment>
				<entry>
					<observation classCode="OBS" moodCode="EVN ">
						<code code="DE08.50.047.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="{ChineseMedicine/Name}"/>
						<value xsi:type="ST">
							<xsl:value-of select="ChineseMedicine/Description"/>
						</value>
					</observation>
				</entry>
				<xsl:comment>HDSD00.16.050 DE06.00.136.00 中药用药方法 条目</xsl:comment>
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.136.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="{UsageMethod/Name}"/>
						<value xsi:type="ST">
							<xsl:value-of select="UsageMethod/Description"/>
						</value>
					</observation>
				</entry>
				<xsl:comment>HDSD00.16.007 DE06.00.287.00 出院医嘱 条目</xsl:comment>
				<entry typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.287.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="{LeaveHospital/Name}"/>
						<value xsi:type="ST">
							<xsl:value-of select="LeaveHospital/Description"/>
						</value>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
</xsl:stylesheet>
